#!/usr/bin/env bash
# Plugin host: discover by header, order by dependencies, run each plugin in isolation.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--plugins DIR] [--disable NAME]... list | run HOOK [ARG...]" >&2
  exit 2
}

dir=plugins
declare -A disabled
while (( $# > 0 )); do
  case $1 in
    --plugins) [[ -n ${2:-} ]] || usage; dir=$2; shift 2 ;;
    --disable) [[ -n ${2:-} ]] || usage; disabled[$2]=1; shift 2 ;;
    -*) usage ;;
    *) break ;;
  esac
done
cmd=${1:-}
case $cmd in
  list) [[ $# -eq 1 ]] || usage ;;
  run)
    [[ $# -ge 2 ]] || usage
    hook=$2
    if [[ ! $hook =~ ^[a-z_]+$ ]]; then
      echo "error: bad hook name '$hook'" >&2
      exit 2
    fi
    shift 2
    ;;
  *) usage ;;
esac
if [[ ! -d $dir ]]; then
  echo "error: cannot read $dir" >&2
  exit 3
fi

# ---- discovery: headers only, nothing is executed -------------------------------
declare -A file_of prio_of req_of
names=() bad_files=() bad_why=()
for f in "$dir"/*.plugin; do
  [[ -f $f ]] || continue
  header=$(head -n 15 "$f")
  name=$(printf '%s\n' "$header" | sed -n -E 's/^# *name: *([^ ]*) *$/\1/p' | head -n 1)
  if [[ ! $name =~ ^[a-z][a-z0-9-]*$ ]]; then
    bad_files+=("${f##*/}") bad_why+=("bad header (no name)")
    continue
  fi
  if [[ -n ${file_of[$name]:-} ]]; then
    bad_files+=("${f##*/}") bad_why+=("bad header (duplicate name)")
    continue
  fi
  prio=$(printf '%s\n' "$header" | sed -n -E 's/^# *priority: *([0-9]+) *$/\1/p' | head -n 1)
  file_of[$name]=$f
  prio_of[$name]=${prio:-50}
  req_of[$name]=$(printf '%s\n' "$header" | sed -n -E 's/^# *requires: *(.*[^ ])? *$/\1/p' | head -n 1)
  names+=("$name")
done
if [[ -f $dir/disabled.list ]]; then
  while IFS= read -r n; do
    [[ -z $n ]] || disabled[$n]=1
  done < "$dir/disabled.list"
fi

# ---- ordering: Kahn's algorithm, lowest (priority, name) first among the ready ----
placed=() 
declare -A is_placed
remaining=("${names[@]:-}")
[[ -n ${remaining[0]:-} ]] || remaining=()
while (( ${#remaining[@]} > 0 )); do
  best=
  for n in "${remaining[@]}"; do
    ready=1
    for r in ${req_of[$n]}; do
      if [[ -n ${file_of[$r]:-} && -z ${is_placed[$r]:-} ]]; then ready=0; break; fi
    done
    (( ready )) || continue
    if [[ -z $best ]] || (( prio_of[$n] < prio_of[$best] )) ||
       { (( prio_of[$n] == prio_of[$best] )) && [[ $n < $best ]]; }; then
      best=$n
    fi
  done
  [[ -n $best ]] || break
  placed+=("$best")
  is_placed[$best]=1
  next=()
  for n in "${remaining[@]}"; do [[ $n == "$best" ]] || next+=("$n"); done
  remaining=("${next[@]:-}")
  [[ -n ${remaining[0]:-} ]] || remaining=()
done
cyclic=("${remaining[@]}")

# ---- status, decided in order ------------------------------------------------------
declare -A status
for n in "${placed[@]:-}"; do
  [[ -n $n ]] || continue
  st=ok
  if [[ -n ${disabled[$n]:-} ]]; then
    st=disabled
  else
    for r in ${req_of[$n]}; do
      if [[ -z ${file_of[$r]:-} ]]; then st="missing dependency: $r"; break; fi
      if [[ -n ${disabled[$r]:-} ]]; then st="dependency disabled: $r"; break; fi
      if [[ ${status[$r]} != ok ]]; then st="dependency not usable: $r"; break; fi
    done
  fi
  status[$n]=$st
done

if [[ $cmd == list ]]; then
  printf '%-5s %-10s %4s  %s\n' ORDER NAME PRIO STATUS
  pos=0 problems=0
  for n in "${placed[@]:-}"; do
    [[ -n $n ]] || continue
    pos=$((pos + 1))
    printf '%-5s %-10s %4s  %s\n' "$pos" "$n" "${prio_of[$n]}" "${status[$n]}"
    [[ ${status[$n]} == ok ]] || problems=1
  done
  if (( ${#cyclic[@]} > 0 )); then
    while IFS= read -r n; do
      printf '%-5s %-10s %4s  %s\n' - "$n" "${prio_of[$n]}" "cyclic dependency"
      problems=1
    done < <(printf '%s\n' "${cyclic[@]}" | sort)
  fi
  for i in "${!bad_files[@]}"; do
    printf '%-5s %-10s %4s  %s\n' - "${bad_files[i]}" - "${bad_why[i]}"
    problems=1
  done
  exit "$problems"
fi

# ---- run ---------------------------------------------------------------------------
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
current=
host_log() { echo "[$current] $*"; }

echo "== hook $hook =="
declare -A failed
ran=0 nfail=0 nskip=0 nohook=0
for n in "${placed[@]:-}"; do
  [[ -n $n ]] || continue
  if [[ ${status[$n]} != ok ]]; then
    echo "$n: skipped (${status[$n]})"
    nskip=$((nskip + 1))
    continue
  fi
  blocker=
  for r in ${req_of[$n]}; do
    if [[ -n ${failed[$r]:-} ]]; then blocker=$r; break; fi
  done
  if [[ -n $blocker ]]; then
    echo "$n: skipped (needs $blocker which failed)"
    nskip=$((nskip + 1))
    continue
  fi
  current=$n
  fn=${n//-/_}__$hook
  rc=0
  # The subshell is the isolation boundary: variables, cwd and exit calls die with it.
  ( 
    # shellcheck disable=SC1090
    source "${file_of[$n]}"
    declare -F "$fn" > /dev/null || exit 78
    "$fn" "$@"
  ) > "$work/out" 2>&1 || rc=$?
  if [[ $rc == 78 ]]; then
    echo "$n: no hook"
    nohook=$((nohook + 1))
    continue
  fi
  cat "$work/out"
  if (( rc == 0 )); then
    echo "$n: ok"
    ran=$((ran + 1))
  else
    echo "$n: FAILED (status $rc)"
    failed[$n]=1
    nfail=$((nfail + 1))
  fi
done
echo "ran: $ran, failed: $nfail, skipped: $nskip, no hook: $nohook"
(( nfail == 0 )) || exit 1

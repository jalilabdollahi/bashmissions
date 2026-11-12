#!/usr/bin/env bash
# Migration runner: numbered .up/.down files, a ledger with fingerprints, and a
# refusal to proceed when history has been rewritten.
set -euo pipefail

usage() {
  echo "usage: solution.sh DIR LEDGER status | up [--dry-run] [--allow-out-of-order] [TARGET] | down [N] | verify" >&2
  exit 2
}

[[ $# -ge 3 ]] || usage
dir=${1%/} ledger=$2 cmd=$3
shift 3
[[ -d $dir ]] || { echo "not a directory: $dir" >&2; exit 2; }

tmp=
cleanup() { [[ -n $tmp ]] && rm -f "$tmp"; return 0; }
trap cleanup EXIT

# --- what is on disk ------------------------------------------------------------
declare -A file_name file_sum have_down
for f in "$dir"/*.up "$dir"/*.down; do
  [[ -f $f ]] || continue
  base=${f##*/}
  [[ $base =~ ^([0-9]{3})-([a-z0-9-]+)\.(up|down)$ ]] || continue
  id=${BASH_REMATCH[1]} name=${BASH_REMATCH[2]} kind=${BASH_REMATCH[3]}
  if [[ $kind == down ]]; then
    have_down[$id]=$base
    continue
  fi
  if [[ -n ${file_name[$id]:-} ]]; then
    echo "duplicate migration id $id" >&2
    exit 2
  fi
  file_name[$id]=$name
  read -r sum _ < <(cksum < "$f")
  file_sum[$id]=$sum
done

# --- what the ledger says ---------------------------------------------------------
declare -A led_sum led_name
led_ids=()
if [[ -r $ledger ]]; then
  while read -r id sum name; do
    [[ -n $id ]] || continue
    led_sum[$id]=$sum led_name[$id]=$name
    led_ids+=("$id")
  done < "$ledger"
fi

sorted() { (( $# )) && printf '%s\n' "$@" | LC_ALL=C sort -u; return 0; }

# state ID -> applied | MODIFIED | MISSING | pending
state() {
  local id=$1
  if [[ -n ${led_sum[$id]:-} ]]; then
    if [[ -z ${file_name[$id]:-} ]]; then echo MISSING
    elif [[ ${file_sum[$id]} == "${led_sum[$id]}" ]]; then echo applied
    else echo MODIFIED; fi
  else
    echo pending
  fi
}
name_of() { echo "${file_name[$1]:-${led_name[$1]:-?}}"; }

all_ids=()
mapfile -t all_ids < <(sorted "${!file_name[@]}" "${led_ids[@]}")
newest=
(( ${#led_ids[@]} == 0 )) || newest=$(sorted "${led_ids[@]}" | tail -n 1)

run_file() {   # ID KIND -> runs dbexec, sets $rc
  local id=$1 kind=$2
  rc=0
  dbexec "$dir/$id-$(name_of "$id").$kind" || rc=$?
}

# rewrite_ledger_without ID: temp file + mv
rewrite_ledger_without() {
  local id=$1 i
  tmp=$(mktemp "$ledger.XXXXXX")
  for i in "${led_ids[@]}"; do
    [[ $i == "$id" ]] && continue
    echo "$i ${led_sum[$i]} ${led_name[$i]}"
  done > "$tmp"
  mv -f "$tmp" "$ledger"
  tmp=
}

case $cmd in
  status)
    [[ $# -eq 0 ]] || usage
    for id in "${all_ids[@]:-}"; do
      [[ -n $id ]] && printf '%s %-14s %s\n' "$id" "$(name_of "$id")" "$(state "$id")"
    done
    ;;
  verify)
    [[ $# -eq 0 ]] || usage
    problems=0
    for id in $(sorted "${led_ids[@]}"); do
      s=$(state "$id")
      if [[ $s == MISSING || $s == MODIFIED ]]; then
        echo "$s $id $(name_of "$id")"
        problems=$((problems + 1))
      fi
    done
    if (( problems > 0 )); then exit 3; fi
    echo "OK: ${#led_ids[@]} migrations verified"
    ;;
  up)
    dry=0 ooo=0 target=
    for a in "$@"; do
      case $a in
        --dry-run) dry=1 ;;
        --allow-out-of-order) ooo=1 ;;
        [0-9][0-9][0-9]) target=$a ;;
        *) usage ;;
      esac
    done
    if [[ -n $target && -z ${file_name[$target]:-} ]]; then
      echo "unknown migration $target" >&2
      exit 2
    fi
    # history first: ledger entries in id order, then pending ones
    for id in $(sorted "${led_ids[@]}"); do
      case $(state "$id") in
        MODIFIED) echo "refusing to migrate: $id was modified after it was applied" >&2; exit 3 ;;
        MISSING)  echo "refusing to migrate: $id is missing from $dir" >&2; exit 3 ;;
      esac
    done
    pending=()
    for id in "${all_ids[@]:-}"; do
      [[ -n $id && $(state "$id") == pending ]] || continue
      if (( ! ooo )) && [[ -n $newest && $id < $newest ]]; then
        echo "refusing to migrate: $id is older than the newest applied migration ($newest)" >&2
        exit 3
      fi
      [[ -z $target || ! $id > $target ]] && pending+=("$id")
    done
    if (( ${#pending[@]} == 0 )); then
      echo "nothing to do"
      exit 0
    fi
    if (( dry )); then
      for id in "${pending[@]}"; do echo "would apply $id $(name_of "$id")"; done
      echo "up complete: ${#pending[@]} pending (dry run)"
      exit 0
    fi
    applied=0
    for id in "${pending[@]}"; do
      run_file "$id" up
      if (( rc != 0 )); then
        echo "FAILED $id $(name_of "$id") (exit $rc)" >&2
        exit 1
      fi
      echo "$id ${file_sum[$id]} ${file_name[$id]}" >> "$ledger"
      echo "applied $id ${file_name[$id]}"
      applied=$((applied + 1))
    done
    echo "up complete: $applied applied"
    ;;
  down)
    count=${1:-1}
    [[ $# -le 1 && $count =~ ^[1-9][0-9]*$ ]] || usage
    if (( ${#led_ids[@]} == 0 )); then
      echo "nothing to revert"
      exit 0
    fi
    mapfile -t newest_first < <(sorted "${led_ids[@]}" | sort -r)
    done_n=0
    for id in "${newest_first[@]}"; do
      (( done_n < count )) || break
      if [[ -z ${have_down[$id]:-} ]]; then
        echo "no down migration for $id" >&2
        exit 1
      fi
      run_file "$id" down
      if (( rc != 0 )); then
        echo "FAILED $id $(name_of "$id") (exit $rc)" >&2
        exit 1
      fi
      rewrite_ledger_without "$id"
      # keep our in-memory view in step with the file
      new_ids=()
      for i in "${led_ids[@]}"; do [[ $i == "$id" ]] || new_ids+=("$i"); done
      led_ids=("${new_ids[@]:-}")
      echo "reverted $id $(name_of "$id")"
      done_n=$((done_n + 1))
    done
    ;;
  *) usage ;;
esac

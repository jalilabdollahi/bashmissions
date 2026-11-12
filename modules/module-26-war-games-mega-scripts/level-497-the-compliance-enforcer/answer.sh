#!/usr/bin/env bash
# Policy enforcer: the same rule engine drives check, enforce and --dry-run.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--dry-run] check|enforce ROOT RULES NOW [WAIVERS]" >&2
  exit 2
}

dry=0
if [[ ${1:-} == --dry-run ]]; then
  dry=1
  shift
fi
[[ $# -ge 4 && $# -le 5 ]] || usage
mode=$1 root=${2%/} rules=$3 now=$4 waivers=${5:-}
case $mode in check|enforce) ;; *) usage ;; esac
(( ! dry )) || [[ $mode == enforce ]] || usage
[[ $now =~ ^[0-9]+$ ]] || usage
for f in "$rules" ${waivers:+"$waivers"}; do
  [[ -r $f ]] || { echo "cannot read $f" >&2; exit 2; }
done

tmp=
cleanup() { [[ -n $tmp ]] && rm -f "$tmp"; return 0; }
trap cleanup EXIT

# --- parse the rules -----------------------------------------------------------
ids=()
declare -A sev type path rest
bad=0
n=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
  read -r id s t p r <<< "$line"
  err() { echo "rules line $n: $1" >&2; bad=1; }
  case $s in high|medium|low) ;; *) err "bad severity '$s'"; continue ;; esac
  case $t in mode|line|noline|setting|absent) ;; *) err "unknown type '$t'"; continue ;; esac
  if [[ -n ${type[$id]:-} ]]; then err "duplicate id '$id'"; continue; fi
  if [[ -z ${p:-} || $p == /* || $p == *..* ]]; then err "path escapes ROOT"; continue; fi
  case $t in
    mode)
      [[ -n ${r:-} && $r != *" "* ]] || { err "wrong arguments"; continue; }
      [[ $r =~ ^[0-7]{3,4}$ ]] || { err "bad mode '$r'"; continue; } ;;
    line|noline) [[ -n ${r:-} ]] || { err "wrong arguments"; continue; } ;;
    setting)     [[ ${r:-} == *" "* ]] || { err "wrong arguments"; continue; } ;;
    absent)      [[ -z ${r:-} ]] || { err "wrong arguments"; continue; } ;;
  esac
  ids+=("$id")
  sev[$id]=$s type[$id]=$t path[$id]=$p rest[$id]=${r:-}
done < "$rules"
(( bad == 0 )) || exit 2

# --- waivers ---------------------------------------------------------------------
declare -A wuntil wreason
if [[ -n $waivers ]]; then
  n=0
  while IFS= read -r line || [[ -n $line ]]; do
    n=$((n + 1))
    [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
    read -r id u why <<< "$line"
    if [[ ! ${u:-} =~ ^until=([0-9]+)$ ]]; then
      echo "waivers line $n: bad waiver" >&2
      exit 2
    fi
    wuntil[$id]=${BASH_REMATCH[1]}
    wreason[$id]=${why:-no reason}
  done < "$waivers"
fi

# --- helpers -----------------------------------------------------------------------
# mode_of PATH -> the rwx bits as a 4-digit octal string, read from ls -ld
mode_of() {
  local perms i c val
  local -a bits=()
  perms=$(ls -ld "$1")
  perms=${perms%% *}
  for i in 1 2 3 4 5 6 7 8 9; do
    c=${perms:i:1}
    val=0
    case $((i % 3)) in
      1) [[ $c == r ]] && val=4 ;;
      2) [[ $c == w ]] && val=2 ;;
      0) [[ $c == x || $c == s || $c == t ]] && val=1 ;;
    esac
    bits[i]=$val
  done
  printf '0%d%d%d' \
    $((bits[1] + bits[2] + bits[3])) \
    $((bits[4] + bits[5] + bits[6])) \
    $((bits[7] + bits[8] + bits[9]))
}
want_mode() {   # 3 or 4 digit mode -> 4 digits, special bits dropped
  local m=$1
  m=${m: -3}
  printf '0%s' "$m"
}

# evaluate ID -> returns 0 when compliant, else 1 with $msg set
msg=
evaluate() {
  local id=$1 f=$root/${path[$1]} t=${type[$1]} r=${rest[$1]} key want cur count line
  case $t in
    mode)
      if [[ ! -e $f ]]; then msg="${path[$id]} does not exist"; return 1; fi
      cur=$(mode_of "$f")
      want=$(want_mode "$r")
      if [[ $cur != "$want" ]]; then msg="${path[$id]} has mode $cur, wants $want"; return 1; fi ;;
    line)
      if [[ ! -f $f ]] || ! grep -qxF -- "$r" "$f"; then
        msg="${path[$id]} is missing the required line"; return 1
      fi ;;
    noline)
      [[ -f $f ]] || return 0
      count=$(grep -cE -- "$r" "$f" || true)
      if (( count > 0 )); then msg="${path[$id]} has $count forbidden line(s)"; return 1; fi ;;
    setting)
      key=${r%% *}
      want=${r#* }
      cur=
      found=0
      if [[ -f $f ]]; then
        while IFS= read -r line || [[ -n $line ]]; do
          [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
          read -r k v <<< "$line"
          if [[ ${k,,} == "${key,,}" ]]; then found=1; cur=${v:-}; break; fi
        done < "$f"
      fi
      if (( ! found )); then msg="$key is not set"; return 1; fi
      if [[ $cur != "$want" ]]; then msg="$key is '$cur', wants '$want'"; return 1; fi ;;
    absent)
      if [[ -e $f || -L $f ]]; then msg="${path[$id]} exists"; return 1; fi ;;
  esac
  return 0
}

# can_fix ID -> 0 if a fix is possible (uses the current failure)
can_fix() {
  local id=$1 f=$root/${path[$1]}
  case ${type[$id]} in
    mode)            [[ -e $f ]] ;;
    absent)          [[ ! -d $f ]] ;;
    line|setting)    [[ -d $(dirname "$f") ]] ;;
    noline)          [[ -f $f ]] ;;
  esac
}

fixtext=
fix_text() {   # ID -> sets fixtext for the current state
  local id=$1 f=$root/${path[$1]} r=${rest[$1]} count
  case ${type[$id]} in
    mode)    fixtext="chmod $(want_mode "$r") ${path[$id]}" ;;
    line)    fixtext="appended line to ${path[$id]}" ;;
    noline)
      count=$(grep -cE -- "$r" "$f" || true)
      fixtext="removed $count line(s) from ${path[$id]}" ;;
    setting) fixtext="set ${r%% *}=${r#* } in ${path[$id]}" ;;
    absent)  fixtext="removed ${path[$id]}" ;;
  esac
}

declare -A backed_up
backup() {   # ID: keep the first original of each file, with its mode
  local rel=${path[$1]} f=$root/${path[$1]}
  [[ -f $f && -z ${backed_up[$rel]:-} ]] || return 0
  backed_up[$rel]=1
  [[ -e $root/.compliance-backup/$rel ]] && return 0
  mkdir -p "$(dirname "$root/.compliance-backup/$rel")"
  cp -p "$f" "$root/.compliance-backup/$rel"
}

apply_fix() {
  local id=$1 f=$root/${path[$1]} r=${rest[$1]} key val line replaced
  backup "$id"
  case ${type[$id]} in
    mode) chmod "$(want_mode "$r")" "$f" ;;
    line)
      if [[ -s $f && -n $(tail -c 1 "$f") ]]; then printf '\n' >> "$f"; fi
      printf '%s\n' "$r" >> "$f" ;;
    noline)
      tmp=$(mktemp "$root/.compliance-tmp.XXXXXX")
      grep -vE -- "$r" "$f" > "$tmp" || true
      cat "$tmp" > "$f"        # overwrite in place so the original mode survives
      rm -f "$tmp"; tmp= ;;
    setting)
      key=${r%% *} val=${r#* }
      tmp=$(mktemp "$root/.compliance-tmp.XXXXXX")
      replaced=0
      if [[ -f $f ]]; then
        while IFS= read -r line || [[ -n $line ]]; do
          if (( ! replaced )) && [[ ! $line =~ ^[[:space:]]*(#|$) ]]; then
            read -r k _ <<< "$line"
            if [[ ${k,,} == "${key,,}" ]]; then
              printf '%s %s\n' "$key" "$val" >> "$tmp"
              replaced=1
              continue
            fi
          fi
          printf '%s\n' "$line" >> "$tmp"
        done < "$f"
      fi
      (( replaced )) || printf '%s %s\n' "$key" "$val" >> "$tmp"
      cat "$tmp" > "$f"
      rm -f "$tmp"; tmp= ;;
    absent) rm -f "$f" ;;
  esac
}

# --- run ------------------------------------------------------------------------------
pass=0 fixed=0 waived=0 failed=0
for id in "${ids[@]}"; do
  s=${sev[$id]}
  if [[ -n ${wuntil[$id]:-} ]]; then
    if (( wuntil[$id] >= now )); then
      echo "WAIVED $id ($s) until ${wuntil[$id]}: ${wreason[$id]}"
      waived=$((waived + 1))
      continue
    fi
    echo "waiver for $id expired" >&2
  fi
  if evaluate "$id"; then
    echo "PASS $id"
    pass=$((pass + 1))
    continue
  fi
  if [[ $mode == check ]]; then
    echo "FAIL $id ($s): $msg"
    failed=$((failed + 1))
    continue
  fi
  failure=$msg
  if ! can_fix "$id"; then
    echo "CANNOT FIX $id ($s): $failure"
    failed=$((failed + 1))
    continue
  fi
  fix_text "$id"
  if (( dry )); then
    echo "WOULD FIX $id ($s): $fixtext"
    fixed=$((fixed + 1))
    continue
  fi
  apply_fix "$id"
  if evaluate "$id"; then
    echo "FIXED $id ($s): $fixtext"
    fixed=$((fixed + 1))
  else
    echo "STILL FAILING $id ($s): $msg"
    failed=$((failed + 1))
  fi
done

echo "summary: pass=$pass fixed=$fixed waived=$waived failed=$failed"
if (( failed > 0 )); then exit 1; fi
if (( dry && fixed > 0 )); then exit 1; fi
exit 0

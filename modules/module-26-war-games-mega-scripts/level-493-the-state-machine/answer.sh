#!/usr/bin/env bash
# Ticket state machine: a transition table with guards, validated statically
# and enforced at run time.
set -euo pipefail

usage() {
  echo "usage: solution.sh MACHINE validate | show TICKET | fire TICKET EVENT ROLE [FIELD=VALUE...]" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
machine=$1 mode=$2
shift 2
case $mode in
  validate) [[ $# -eq 0 ]] || usage ;;
  show)     [[ $# -eq 1 ]] || usage ;;
  fire)     [[ $# -ge 3 ]] || usage ;;
  *) usage ;;
esac
[[ -r $machine ]] || { echo "cannot read $machine" >&2; exit 2; }

name_re='^[a-z][a-z0-9_-]*$'

# --- load the machine ------------------------------------------------------
initial=
declare -A final to roles req events isstate
dups=()
order=()           # transition keys in file order (without duplicates)
bad=0
n=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
  read -ra w <<< "$line"
  case ${w[0]} in
    initial)
      if (( ${#w[@]} == 2 )) && [[ ${w[1]} =~ $name_re ]]; then
        initial=${w[1]}; isstate[$initial]=1
      else echo "$machine:$n: bad line" >&2; bad=1; fi ;;
    final)
      ok=1
      (( ${#w[@]} == 2 )) || ok=0
      if (( ok )); then
        IFS=, read -ra fs <<< "${w[1]}"
        for s in "${fs[@]}"; do [[ $s =~ $name_re ]] || ok=0; done
      fi
      if (( ok )); then
        for s in "${fs[@]}"; do final[$s]=1; isstate[$s]=1; done
      else echo "$machine:$n: bad line" >&2; bad=1; fi ;;
    *)
      ok=1
      (( ${#w[@]} >= 3 )) || ok=0
      if (( ok )); then
        for x in "${w[@]:0:3}"; do [[ $x =~ $name_re ]] || ok=0; done
      fi
      r= q=
      if (( ok )); then
        for opt in "${w[@]:3}"; do
          case $opt in
            role=*)    r=${opt#role=}; [[ $r =~ ^[a-z][a-z0-9_-]*(,[a-z][a-z0-9_-]*)*$ ]] || ok=0 ;;
            require=*) q=${opt#require=}; [[ $q =~ $name_re ]] || ok=0 ;;
            *) ok=0 ;;
          esac
        done
      fi
      if (( ! ok )); then
        echo "$machine:$n: bad line" >&2; bad=1
      else
        from=${w[0]} ev=${w[1]} dest=${w[2]}
        isstate[$from]=1; isstate[$dest]=1
        if [[ -n ${to[$from|$ev]:-} ]]; then
          dups+=("$from $ev")
        else
          to[$from|$ev]=$dest roles[$from|$ev]=$r req[$from|$ev]=$q
          events[$from]+="$ev "
          order+=("$from|$ev")
        fi
      fi ;;
  esac
done < "$machine"
(( bad == 0 )) || exit 2
[[ -n $initial ]] || { echo "$machine: no initial state" >&2; exit 2; }

sorted_events() {   # STATE -> "a, b" or "none"
  local list
  list=$(printf '%s\n' ${events[$1]:-} | LC_ALL=C sort | paste -s -d, - | sed 's/,/, /g')
  echo "${list:-none}"
}

# --- validate ----------------------------------------------------------------
if [[ $mode == validate ]]; then
  declare -A seen
  queue=("$initial")
  seen[$initial]=1
  while (( ${#queue[@]} > 0 )); do
    cur=${queue[0]}
    queue=("${queue[@]:1}")
    for ev in ${events[$cur]:-}; do
      nxt=${to[$cur|$ev]}
      if [[ -z ${seen[$nxt]:-} ]]; then seen[$nxt]=1; queue+=("$nxt"); fi
    done
  done
  problems=0
  for d in "${dups[@]:-}"; do
    [[ -n $d ]] && { echo "duplicate transition: $d"; problems=$((problems + 1)); }
  done
  states=$(printf '%s\n' "${!isstate[@]}" | LC_ALL=C sort)
  for s in $states; do
    [[ -n ${seen[$s]:-} ]] || { echo "unreachable state: $s"; problems=$((problems + 1)); }
  done
  for s in $states; do
    if [[ -z ${final[$s]:-} && -z ${events[$s]:-} ]]; then
      echo "dead end: $s"; problems=$((problems + 1))
    fi
  done
  for s in $states; do
    if [[ -n ${final[$s]:-} && -n ${events[$s]:-} ]]; then
      echo "final state has outgoing transitions: $s"; problems=$((problems + 1))
    fi
  done
  if (( problems > 0 )); then
    echo "$problems problems found"
    exit 1
  fi
  echo "OK: ${#isstate[@]} states, ${#order[@]} transitions"
  exit 0
fi

# --- load the ticket ---------------------------------------------------------
ticket=$1
shift
state=$initial
declare -A field
history=()
if [[ -e $ticket ]]; then
  while IFS= read -r line || [[ -n $line ]]; do
    [[ -z $line ]] && continue
    key=${line%%=*} val=${line#*=}
    case $key in
      state)   state=$val ;;
      history) history+=("$val") ;;
      *)       field[$key]=$val ;;
    esac
  done < "$ticket"
fi
if [[ -z ${isstate[$state]:-} ]]; then
  echo "corrupt ticket $ticket: unknown state '$state'" >&2
  exit 2
fi

if [[ $mode == show ]]; then
  echo "state: $state"
  echo "allowed: $(sorted_events "$state")"
  echo "steps: ${#history[@]}"
  for key in $(printf '%s\n' "${!field[@]}" | LC_ALL=C sort); do
    [[ -n $key ]] && echo "field $key=${field[$key]}"
  done
  exit 0
fi

# --- fire ------------------------------------------------------------------
ev=$1 role=$2
shift 2
declare -A newfield
for kv in "$@"; do
  [[ $kv =~ ^([a-z][a-z0-9_]*)=(.*)$ ]] || usage
  newfield[${BASH_REMATCH[1]}]=${BASH_REMATCH[2]}
done

key=$state'|'$ev
if [[ -z ${to[$key]:-} ]]; then
  echo "illegal: event '$ev' not allowed in state '$state' (allowed: $(sorted_events "$state"))" >&2
  exit 1
fi
if [[ -n ${roles[$key]} ]]; then
  case ",${roles[$key]}," in
    *",$role,"*) ;;
    *) echo "denied: role '$role' may not '$ev' (needs: ${roles[$key]//,/, })" >&2; exit 3 ;;
  esac
fi
for k in "${!newfield[@]}"; do field[$k]=${newfield[$k]}; done
if [[ -n ${req[$key]} && -z ${field[${req[$key]}]:-} ]]; then
  echo "blocked: field '${req[$key]}' is required" >&2
  exit 4
fi

dest=${to[$key]}
history+=("$state $ev $dest $role")
tmp=$(mktemp "$ticket.XXXXXX")
trap 'rm -f "$tmp"' EXIT
{
  echo "state=$dest"
  for k in $(printf '%s\n' "${!field[@]}" | LC_ALL=C sort); do
    [[ -n $k ]] && echo "$k=${field[$k]}"
  done
  for h in "${history[@]}"; do echo "history=$h"; done
} > "$tmp"
mv -f "$tmp" "$ticket"
echo "$state -> $dest ($ev by $role)"

#!/usr/bin/env bash
# Multi-environment promotion with gates, health verification and rollback.
set -euo pipefail

usage() {
  echo "usage: solution.sh status APP | [--dry-run] promote APP FROM TO" >&2
  exit 2
}
die() { echo "error: $1" >&2; exit "${2:-3}"; }

dry=0
if [[ ${1:-} == --dry-run ]]; then
  dry=1
  shift
fi
cmd=${1:-}
case $cmd in
  status) [[ $# -eq 2 && $dry -eq 0 ]] || usage ;;
  promote) [[ $# -eq 4 ]] || usage ;;
  *) usage ;;
esac
app=$2
now=${NOW:-$(date +%s)}
deployer=${DEPLOYER:-${USER:-unknown}}

# --- configuration -------------------------------------------------------
conf=pipeline.conf
[[ -r $conf ]] || die "pipeline.conf is missing"
order=()
declare -A in_order
gate_names=() gate_args=() gate_envs=()
lineno=0
while IFS='|' read -r kind f2 f3 f4; do
  lineno=$((lineno + 1))
  [[ -z $kind || $kind == \#* ]] && continue
  case $kind in
    order)
      read -ra order <<< "$f2"
      for e in "${order[@]}"; do in_order[$e]=1; done
      ;;
    gate)
      [[ ${#order[@]} -gt 0 ]] || die "pipeline.conf has no order line"
      [[ -n ${in_order[$f2]:-} ]] || die "pipeline.conf line $lineno: unknown environment '$f2'"
      case $f3 in
        soak) [[ $f4 =~ ^[0-9]+$ ]] || die "pipeline.conf line $lineno: bad soak minutes '$f4'" ;;
        tests | approval | freeze) ;;
        *) die "pipeline.conf line $lineno: unknown gate '$f3'" ;;
      esac
      gate_envs+=("$f2") gate_names+=("$f3") gate_args+=("$f4")
      ;;
  esac
done < "$conf"
[[ ${#order[@]} -gt 0 ]] || die "pipeline.conf has no order line"

state=state/$app
read_state() { [[ -f $state/$1.$2 ]] && cat "$state/$1.$2" || true; }

# --- status ----------------------------------------------------------------
if [[ $cmd == status ]]; then
  printf '%-8s %-10s %s\n' ENV VERSION AGE
  for e in "${order[@]}"; do
    v=$(read_state "$e" version)
    s=$(read_state "$e" since)
    if [[ -n $v && $s =~ ^[0-9]+$ ]]; then
      printf '%-8s %-10s %s\n' "$e" "$v" "$(( (now - s) / 60 )) min"
    else
      printf '%-8s %-10s %s\n' "$e" "${v:--}" "-"
    fi
  done
  exit 0
fi

# --- promote -----------------------------------------------------------------
from=$3 to=$4
pos_from=-1 pos_to=-1
for i in "${!order[@]}"; do
  [[ ${order[i]} == "$from" ]] && pos_from=$i
  [[ ${order[i]} == "$to" ]] && pos_to=$i
done
if (( pos_from < 0 || pos_to != pos_from + 1 )); then
  die "$to does not follow $from in the pipeline"
fi
version=$(read_state "$from" version)
[[ -n $version ]] || die "$from has no version of $app"
previous=$(read_state "$to" version)
if [[ $previous == "$version" ]]; then
  echo "$to already runs $version"
  exit 0
fi

echo "promote $app $version: $from -> $to"
failed=0
for i in "${!gate_names[@]}"; do
  [[ ${gate_envs[i]} == "$to" ]] || continue
  gate=${gate_names[i]} arg=${gate_args[i]}
  label=$gate
  ok=1 detail=
  case $gate in
    soak)
      label="soak($arg)"
      since=$(read_state "$from" since)
      if [[ ! $since =~ ^[0-9]+$ ]]; then
        ok=0 detail="no arrival time"
      else
        mins=$(( (now - since) / 60 ))
        if (( mins >= arg )); then detail="$mins min in $from"
        else ok=0 detail="$mins min in $from, need $arg"
        fi
      fi
      ;;
    tests)
      if ! smoke-test "$from" "$app" "$version" > /dev/null 2>&1; then
        ok=0 detail="smoke-test failed"
      fi
      ;;
    approval)
      file=approvals/$app-$version-$to
      if [[ ! -r $file ]]; then
        ok=0 detail="no approval file $file"
      else
        approver=$(sed -n 's/^approver=//p' "$file" | head -n 1)
        if [[ -z $approver ]]; then
          ok=0 detail="approval file names no approver"
        elif [[ $approver == "$deployer" ]]; then
          ok=0 detail="self-approval is not allowed"
        else
          detail="approved by $approver"
        fi
      fi
      ;;
    freeze)
      if [[ -e FREEZE ]]; then
        ok=0 detail="change freeze: $(head -n 1 FREEZE)"
      fi
      ;;
  esac
  result=PASS
  (( ok )) || { result=FAIL; failed=$((failed + 1)); }
  if [[ -n $detail ]]; then echo "gate $label: $result ($detail)"; else echo "gate $label: $result"; fi
done

if (( failed > 0 )); then
  echo "gates failed: $failed - not promoting"
  exit 1
fi
if (( dry )); then
  echo "dry run: gates passed, would deploy $version to $to"
  exit 0
fi

if deployctl push "$app" "$version" "$to" > /dev/null 2>&1; then
  echo "push: ok"
else
  echo "push: FAILED"
  die "push to $to failed" 4
fi
if deployctl health "$to" "$app" > /dev/null 2>&1; then
  echo "health: ok"
else
  echo "health: FAILED"
  if [[ -n $previous ]]; then
    if ! deployctl push "$app" "$previous" "$to" > /dev/null 2>&1; then
      die "rollback of $to to $previous failed" 7
    fi
    echo "rolled back $to to $previous"
    die "health check failed after promotion" 5
  fi
  die "health check failed and $to has no previous version" 6
fi

mkdir -p "$state"
printf '%s\n' "$version" > "$state/$to.version"
printf '%s\n' "$now" > "$state/$to.since"
echo "$now promote $version $from->$to by $deployer" >> "$state/history.log"
echo "promoted $app $version to $to (previous: ${previous:-none})"

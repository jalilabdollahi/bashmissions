#!/usr/bin/env bash
# Incident responder: evaluate threshold rules, snapshot evidence, respect a cooldown.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--cooldown SECONDS] [--keep N] RULES SAMPLE" >&2
  exit 2
}

cooldown=300
keep=5
while (( $# > 0 )); do
  case $1 in
    --cooldown)
      if [[ ! ${2:-} =~ ^[0-9]+$ ]]; then
        echo "error: --cooldown needs a whole number" >&2
        exit 2
      fi
      cooldown=$2
      shift 2
      ;;
    --keep)
      if [[ ! ${2:-} =~ ^[1-9][0-9]*$ ]]; then
        echo "error: --keep needs a positive whole number" >&2
        exit 2
      fi
      keep=$2
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 2 ]] || usage
rules=$1
sample=$2
for f in "$rules" "$sample"; do
  if [[ ! -r $f ]]; then
    echo "error: cannot read $f" >&2
    exit 2
  fi
done
now=${NOW:-$(date +%s)}

num_re='^-?[0-9]+(\.[0-9]+)?$'

# Validate every rule before evaluating anything.
names=() keys=() ops=() thrs=() cols=()
lineno=0
while IFS='|' read -r name key op thr collectors; do
  lineno=$((lineno + 1))
  [[ -z $name || $name == \#* ]] && continue
  if [[ -z $key || -z $op || -z $thr || -z $collectors ]]; then
    echo "error: $rules line $lineno: need NAME|KEY|OP|THRESHOLD|COLLECTORS" >&2
    exit 3
  fi
  case $op in
    '>' | '>=' | '<' | '<=' | '==') ;;
    *) echo "error: $rules line $lineno: bad operator '$op'" >&2; exit 3 ;;
  esac
  if [[ ! $thr =~ $num_re ]]; then
    echo "error: $rules line $lineno: bad threshold '$thr'" >&2
    exit 3
  fi
  IFS=',' read -ra parts <<< "$collectors"
  for c in "${parts[@]}"; do
    case $c in
      procs | disk | net) ;;
      logs:?*:[0-9]*) ;;
      *) echo "error: $rules line $lineno: unknown collector '$c'" >&2; exit 3 ;;
    esac
  done
  names+=("$name") keys+=("$key") ops+=("$op") thrs+=("$thr") cols+=("$collectors")
done < "$rules"

declare -A metric
while IFS='=' read -r k v; do
  [[ -n $k ]] && metric[$k]=$v
done < "$sample"

mkdir -p incidents/.last
tmp=
trap '[[ -z $tmp ]] || rm -rf "$tmp"' EXIT

# breached VALUE OP THRESHOLD: numeric comparison done by awk.
breached() {
  awk -v v="$1" -v op="$2" -v t="$3" 'BEGIN {
    if (op == ">") r = (v + 0 > t + 0)
    else if (op == ">=") r = (v + 0 >= t + 0)
    else if (op == "<") r = (v + 0 < t + 0)
    else if (op == "<=") r = (v + 0 <= t + 0)
    else r = (v + 0 == t + 0)
    exit !r
  }'
}

# collect SPEC DIR: run one collector, store its output in $out; returns 1 if the command failed.
out=
collect() {
  local spec=$1 dir=$2 path n
  case $spec in
    procs) out=$dir/procs.txt; ps aux > "$out" 2> /dev/null ;;
    disk) out=$dir/disk.txt; df -P > "$out" 2> /dev/null ;;
    net) out=$dir/net.txt; ss -tn > "$out" 2> /dev/null ;;
    logs:*)
      path=${spec#logs:}
      n=${path##*:}
      path=${path%:*}
      out=$dir/log-${path##*/}.txt
      tail -n "$n" "$path" > "$out" 2> /dev/null
      ;;
  esac
}

breaches=0 snapshots=0 pruned=0
for i in "${!names[@]}"; do
  name=${names[i]} key=${keys[i]} op=${ops[i]} thr=${thrs[i]}
  value=${metric[$key]:-}
  if [[ ! $value =~ $num_re ]]; then
    echo "rule $name: no data for $key"
    continue
  fi
  if ! breached "$value" "$op" "$thr"; then
    echo "rule $name: ok ($key=$value)"
    continue
  fi
  breaches=$((breaches + 1))
  head="rule $name: BREACH $key=$value ($op $thr)"

  if [[ -f incidents/.last/$name ]]; then
    last=$(< "incidents/.last/$name")
    if [[ $last =~ ^[0-9]+$ ]] && (( now - last < cooldown )); then
      echo "$head - cooling down ($((cooldown - (now - last))) s left)"
      continue
    fi
  fi

  seq=0
  [[ -f incidents/.seq ]] && seq=$(< incidents/.seq)
  seq=$((seq + 1))
  id=$(printf 'INC-%04d-%s' "$seq" "$name")
  tmp=$(mktemp -d incidents/.tmp-XXXXXX)
  {
    echo "rule=$name"; echo "key=$key"; echo "value=$value"
    echo "op=$op"; echo "threshold=$thr"; echo "at=$now"
  } > "$tmp/trigger.txt"
  failed=()
  IFS=',' read -ra specs <<< "${cols[i]}"
  for spec in "${specs[@]}"; do
    if ! collect "$spec" "$tmp"; then
      echo "collector failed" > "$out"
      failed+=("$spec")
    fi
  done
  mv "$tmp" "incidents/$id"
  tmp=
  echo "$seq" > incidents/.seq
  echo "$now" > "incidents/.last/$name"
  echo "$id|$now|$value" >> incidents/INDEX
  snapshots=$((snapshots + 1))
  echo "$head - snapshot $id (${#specs[@]} collectors)"
  for spec in "${failed[@]:-}"; do
    [[ -z $spec ]] || echo "  ! collector ${spec%%:*} failed"
  done

  # retention: INC-NNNN names sort by sequence number
  mapfile -t snaps < <(cd incidents && ls -d INC-* | sort)
  excess=$(( ${#snaps[@]} - keep ))
  for (( j = 0; j < excess; j++ )); do
    rm -rf "incidents/${snaps[j]}"
    pruned=$((pruned + 1))
  done
done

echo "breaches: $breaches, snapshots: $snapshots, pruned: $pruned"
(( breaches == 0 )) || exit 1

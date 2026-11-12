#!/usr/bin/env bash
# Dependency resolver: Kahn's algorithm by layers, plus a readable cycle report.
set -euo pipefail

usage() {
  echo "usage: solution.sh levels|order|stop GRAPH [TARGET...] | check GRAPH" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
mode=$1 graph=$2
shift 2
case $mode in
  levels|order|stop) ;;
  check) [[ $# -eq 0 ]] || usage ;;
  *) usage ;;
esac
[[ -r $graph ]] || { echo "cannot read $graph" >&2; exit 2; }

# --- parse: collect every problem, then stop --------------------------------
declare -A deps defline dependents
names=()
problems=0
msgs=()
# problem LINE MESSAGE: remember it with a zero-padded line number so the final
# report can be put in file order (unknown dependencies are found in pass two).
problem() {
  msgs+=("$(printf '%06d' "$1") $graph:$1: $2")
  problems=$((problems + 1))
}

n=0
while IFS= read -r line || [[ -n $line ]]; do
  n=$((n + 1))
  [[ $line =~ ^[[:space:]]*(#|$) ]] && continue
  if [[ $line != *:* ]]; then
    problem "$n" "expected NAME: DEPENDENCIES"
    continue
  fi
  name=${line%%:*}
  name=${name#"${name%%[![:space:]]*}"}
  name=${name%"${name##*[![:space:]]}"}
  if [[ ! $name =~ ^[a-z0-9-]+$ ]]; then
    problem "$n" "bad name '$name'"
    continue
  fi
  if [[ -n ${defline[$name]:-} ]]; then
    problem "$n" "duplicate service '$name'"
    continue
  fi
  # unique dependencies, in the order written
  uniq_deps=" "
  for d in ${line#*:}; do
    [[ $uniq_deps == *" $d "* ]] || uniq_deps+="$d "
  done
  deps[$name]=${uniq_deps# }
  defline[$name]=$n
  names+=("$name")
done < "$graph"

# unknown dependencies are reported at the line of the service that names them
for name in "${names[@]}"; do
  for d in ${deps[$name]}; do
    [[ -n ${defline[$d]:-} ]] || problem "${defline[$name]}" "unknown dependency '$d' of '$name'"
  done
done
if (( problems > 0 )); then
  printf '%s\n' "${msgs[@]}" | LC_ALL=C sort -s -k1,1 | cut -d' ' -f2- >&2
  exit 2
fi

# --- which services are in play? targets plus their transitive dependencies --
declare -A inplay
if (( $# == 0 )); then
  for name in "${names[@]}"; do inplay[$name]=1; done
else
  stack=()
  for t in "$@"; do
    [[ -n ${defline[$t]:-} ]] || { echo "unknown service '$t'" >&2; exit 2; }
    stack+=("$t")
  done
  while (( ${#stack[@]} > 0 )); do
    cur=${stack[${#stack[@]} - 1]}
    unset 'stack[${#stack[@]}-1]'
    [[ -n ${inplay[$cur]:-} ]] && continue
    inplay[$cur]=1
    for d in ${deps[$cur]}; do stack+=("$d"); done
  done
fi

# --- Kahn by layers ---------------------------------------------------------
declare -A unmet placed
for name in "${!inplay[@]}"; do
  unmet[$name]=0
  for d in ${deps[$name]}; do
    unmet[$name]=$((unmet[$name] + 1))
    dependents[$d]+="$name "
  done
done

layers=()
remaining=${#inplay[@]}
while (( remaining > 0 )); do
  ready=()
  for name in "${!inplay[@]}"; do
    [[ -z ${placed[$name]:-} && ${unmet[$name]} -eq 0 ]] && ready+=("$name")
  done
  (( ${#ready[@]} > 0 )) || break
  layer=$(printf '%s\n' "${ready[@]}" | LC_ALL=C sort | tr '\n' ' ')
  layers+=("${layer% }")
  for name in "${ready[@]}"; do
    placed[$name]=1
    remaining=$((remaining - 1))
    for waiting in ${dependents[$name]:-}; do
      unmet[$waiting]=$((unmet[$waiting] - 1))
    done
  done
done

# --- cycle: follow the first unplaced dependency until a name repeats -------
if (( remaining > 0 )); then
  left=()
  for name in "${!inplay[@]}"; do
    [[ -z ${placed[$name]:-} ]] && left+=("$name")
  done
  cur=$(printf '%s\n' "${left[@]}" | LC_ALL=C sort | head -n 1)
  path=()
  declare -A onpath
  while [[ -z ${onpath[$cur]:-} ]]; do
    onpath[$cur]=${#path[@]}
    path+=("$cur")
    next=
    for d in $(printf '%s\n' ${deps[$cur]} | LC_ALL=C sort); do
      if [[ -n ${inplay[$d]:-} && -z ${placed[$d]:-} ]]; then next=$d; break; fi
    done
    cur=$next
  done
  out=
  for (( i = onpath[$cur]; i < ${#path[@]}; i++ )); do out+="${path[i]} -> "; done
  echo "cycle detected: $out$cur"
  exit 1
fi

# --- output -------------------------------------------------------------------
case $mode in
  check) echo "OK: ${#inplay[@]} services in ${#layers[@]} levels" ;;
  levels)
    for i in "${!layers[@]}"; do echo "$((i + 1)): ${layers[i]}"; done ;;
  order|stop)
    all=()
    for layer in "${layers[@]}"; do
      for name in $layer; do all+=("$name"); done
    done
    if [[ $mode == order ]]; then
      printf '%s\n' "${all[@]}"
    else
      for (( i = ${#all[@]} - 1; i >= 0; i-- )); do echo "${all[i]}"; done
    fi ;;
esac

#!/usr/bin/env bash
# GitOps-style reconciler: make the live state match the repository, one app at
# a time, verifying every change and undoing the ones that do not work.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--dry-run] [--prune] REPO LIVE NOW" >&2
  exit 2
}

dry=0 prune=0
while [[ ${1:-} == --* ]]; do
  case $1 in
    --dry-run) dry=1 ;;
    --prune)   prune=1 ;;
    *) usage ;;
  esac
  shift
done
[[ $# -eq 3 ]] || usage
repo=${1%/} live=${2%/} now=$3
[[ $now =~ ^[0-9]+$ ]] || usage
[[ -d $repo ]] || { echo "not a directory: $repo" >&2; exit 2; }
[[ -d $live ]] || { echo "not a directory: $live" >&2; exit 2; }
max_changes=${MAX_CHANGES:-5}
[[ $max_changes =~ ^[1-9][0-9]*$ ]] || { echo "invalid MAX_CHANGES" >&2; exit 2; }

# --- 1. a freeze beats everything -------------------------------------------------
if [[ -s $repo/FREEZE ]]; then
  echo "deploy freeze active: $(head -n 1 "$repo/FREEZE")" >&2
  exit 1
fi

# --- 2. one deploy at a time --------------------------------------------------------
if ! mkdir "$live/.lock" 2>/dev/null; then
  echo "another deploy is running" >&2
  exit 1
fi
trap 'rmdir "$live/.lock" 2>/dev/null || true' EXIT

# --- 3. fetch the desired state ------------------------------------------------------
if ! git -C "$repo" pull --ff-only > /dev/null 2>&1; then
  echo "git pull failed, nothing deployed" >&2
  exit 1
fi
sha=$(git -C "$repo" rev-parse --short HEAD)

# --- 4. read and validate the manifests (all problems, then stop) ---------------------
declare -A dver drep dport dorder
names=()
bad=0
for f in "$repo"/apps/*.app; do
  [[ -f $f ]] || continue
  rel=apps/${f##*/}
  name=${f##*/}
  name=${name%.app}
  problem() { echo "invalid manifest $rel: $1" >&2; bad=1; }
  if [[ ! $name =~ ^[a-z0-9-]+$ ]]; then problem "bad name"; continue; fi
  ver= rep=1 port=8080 ord=50
  while IFS='=' read -r key val || [[ -n $key ]]; do
    [[ -z $key || $key == \#* ]] && continue
    case $key in
      version)  [[ $val =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && ver=$val || problem "bad version '$val'" ;;
      replicas) [[ $val =~ ^[0-9]+$ ]] && (( val >= 1 && val <= 20 )) && rep=$((10#$val)) || problem "bad replicas '$val'" ;;
      port)     [[ $val =~ ^[0-9]+$ ]] && (( val >= 1 && val <= 65535 )) && port=$((10#$val)) || problem "bad port '$val'" ;;
      order)    [[ $val =~ ^[0-9]+$ ]] && (( val <= 99 )) && ord=$((10#$val)) || problem "bad order '$val'" ;;
      *)        problem "unknown key '$key'" ;;
    esac
  done < "$f"
  [[ -n $ver ]] || problem "missing version"
  names+=("$name")
  dver[$name]=$ver drep[$name]=$rep dport[$name]=$port dorder[$name]=$ord
done
(( bad == 0 )) || exit 2
if (( ${#names[@]} == 0 )); then
  echo "no applications in $repo/apps" >&2
  exit 2
fi

# --- 5. read the live state ------------------------------------------------------------
declare -A lver lrep lport
live_names=()
for f in "$live"/*.state; do
  [[ -f $f ]] || continue
  name=${f##*/}
  name=${name%.state}
  live_names+=("$name")
  while IFS='=' read -r key val || [[ -n $key ]]; do
    case $key in
      version)  lver[$name]=$val ;;
      replicas) lrep[$name]=$val ;;
      port)     lport[$name]=$val ;;
    esac
  done < "$f"
done

# --- 6. plan: dependencies first (order), then name; removals last --------------------
ordered=$(for n in "${names[@]}"; do printf '%02d %s\n' "${dorder[$n]}" "$n"; done | LC_ALL=C sort | cut -d' ' -f2)
orphans=()
for n in "${live_names[@]:-}"; do
  [[ -n $n && -z ${dver[$n]:-} ]] && orphans+=("$n")
done
mapfile -t orphans < <(printf '%s\n' "${orphans[@]:-}" | sed '/^$/d' | LC_ALL=C sort)

action_of() {   # NAME -> create | update | unchanged
  local n=$1
  if [[ -z ${lver[$n]:-} ]]; then echo create
  elif [[ ${lver[$n]} == "${dver[$n]}" && ${lrep[$n]:-} == "${drep[$n]}" && ${lport[$n]:-} == "${dport[$n]}" ]]; then echo unchanged
  else echo update; fi
}

changes=0
for n in $ordered; do
  [[ $(action_of "$n") == unchanged ]] || changes=$((changes + 1))
done
(( prune )) && changes=$((changes + ${#orphans[@]}))

if (( changes > max_changes )); then
  if (( dry )); then
    echo "warning: $changes changes exceed MAX_CHANGES=$max_changes" >&2
  else
    echo "too many changes ($changes > $max_changes), refusing" >&2
    exit 1
  fi
fi

audit() {   # ACTION NAME DETAIL RESULT
  echo "$now $sha $1 $2 $3 $4" >> "$live/audit.log"
}

write_state() {   # NAME
  printf 'version=%s\nreplicas=%s\nport=%s\n' "${dver[$1]}" "${drep[$1]}" "${dport[$1]}" > "$live/$1.state"
}

created=0 updated=0 deleted=0 rolled=0 failed=0 unchanged=0
for n in $ordered; do
  act=$(action_of "$n")
  case $act in
    unchanged)
      echo "unchanged $n ${dver[$n]}"
      unchanged=$((unchanged + 1))
      continue ;;
    create)
      desc="${dver[$n]}"
      if (( dry )); then echo "would create $n ${dver[$n]}"; created=$((created + 1)); continue; fi ;;
    update)
      desc="${lver[$n]}->${dver[$n]}"
      if (( dry )); then echo "would update $n ${lver[$n]} -> ${dver[$n]}"; updated=$((updated + 1)); continue; fi ;;
  esac
  rc=0
  deployctl apply "$n" "${dver[$n]}" "${drep[$n]}" "${dport[$n]}" || rc=$?
  if (( rc != 0 )); then
    echo "FAILED $n (deployctl exit $rc)"
    audit "$act" "$n" "$desc" failed
    failed=$((failed + 1))
    continue
  fi
  if healthctl "$n"; then
    write_state "$n"
    audit "$act" "$n" "$desc" ok
    if [[ $act == create ]]; then
      echo "created $n ${dver[$n]}"; created=$((created + 1))
    else
      echo "updated $n ${lver[$n]} -> ${dver[$n]}"; updated=$((updated + 1))
    fi
  else
    if [[ $act == create ]]; then
      deployctl remove "$n"
      echo "removed $n (health check failed on create)"
    else
      deployctl apply "$n" "${lver[$n]}" "${lrep[$n]}" "${lport[$n]}"
      echo "rolled back $n ${dver[$n]} -> ${lver[$n]} (health check failed)"
    fi
    audit "$act" "$n" "$desc" rolled-back
    rolled=$((rolled + 1))
  fi
done

for n in "${orphans[@]:-}"; do
  [[ -n $n ]] || continue
  if (( ! prune )); then
    echo "orphan $n (not in repo, use --prune to remove)"
  elif (( dry )); then
    echo "would delete $n"
    deleted=$((deleted + 1))
  else
    deployctl remove "$n"
    rm -f "$live/$n.state"
    audit delete "$n" "${lver[$n]}" ok
    echo "deleted $n"
    deleted=$((deleted + 1))
  fi
done

if (( dry )); then
  echo "plan for $sha: create=$created update=$updated delete=$deleted unchanged=$unchanged"
  exit 0
fi
echo "deploy $sha: created=$created updated=$updated deleted=$deleted rolled-back=$rolled failed=$failed unchanged=$unchanged"
if (( rolled + failed > 0 )); then
  notifyctl send "deploy $sha: $rolled rolled back, $failed failed"
  exit 1
fi

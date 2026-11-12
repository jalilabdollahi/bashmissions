#!/usr/bin/env bash
# Evidence collector with a chain of custody: copy, hash, lock, seal, verify.
set -euo pipefail

usage() {
  echo "usage: solution.sh collect CASE ANALYST NOW SRC... | verify CASE ANALYST NOW" >&2
  exit 2
}

is_uint() { [[ $1 =~ ^[0-9]+$ ]]; }

# sum_of FILE -> "CRC SIZE" as printed by cksum
sum_of() { cksum < "$1"; }

collect() {
  local case_dir=$1 analyst=$2 now=$3 src n=0 name sum size
  shift 3
  local good=()
  for src in "$@"; do
    if [[ -f $src && ! -L $src ]]; then
      good+=("$src")
    else
      echo "skipped $src: not a regular file" >&2
    fi
  done
  if (( ${#good[@]} == 0 )); then
    echo "nothing to collect" >&2
    exit 1
  fi
  mkdir "$case_dir"
  mkdir "$case_dir/evidence"
  : > "$case_dir/manifest.txt"
  for src in "${good[@]}"; do
    n=$((n + 1))
    printf -v name '%03d-%s' "$n" "${src##*/}"
    cp -p "$src" "$case_dir/evidence/$name"
    read -r sum size < <(sum_of "$src")
    if [[ "$(sum_of "$case_dir/evidence/$name")" != "$sum $size" ]]; then
      echo "copy of $src does not match the source" >&2
      exit 3
    fi
    chmod 0444 "$case_dir/evidence/$name"
    printf '%s %s %s %s\n' "$name" "$sum" "$size" "$src" >> "$case_dir/manifest.txt"
  done
  read -r sum _ < <(sum_of "$case_dir/manifest.txt")
  printf '%s\n' "$sum" > "$case_dir/manifest.seal"
  echo "$now $analyst collect $n items" >> "$case_dir/custody.log"
  echo "collected $n items into $case_dir (seal $sum)"
}

verify() {
  local case_dir=$1 analyst=$2 now=$3
  local ok=0 problems=0 sealsum stored name sum size orig actual f
  [[ -d $case_dir ]] || { echo "no such case: $case_dir" >&2; exit 2; }
  [[ -r $case_dir/manifest.txt ]] || { echo "no manifest in $case_dir" >&2; exit 2; }
  read -r sealsum _ < <(sum_of "$case_dir/manifest.txt")
  stored=
  [[ -r $case_dir/manifest.seal ]] && stored=$(< "$case_dir/manifest.seal")
  if [[ $stored == "$sealsum" ]]; then
    echo "seal OK"
  else
    echo "SEAL MISMATCH"
    problems=$((problems + 1))
  fi
  declare -A listed
  while read -r name sum size orig; do
    [[ -n $name ]] || continue
    listed[$name]=1
    f=$case_dir/evidence/$name
    if [[ ! -f $f ]]; then
      echo "MISSING $name"; problems=$((problems + 1))
    else
      read -r actual < <(sum_of "$f")
      if [[ $actual != "$sum $size" ]]; then
        echo "MODIFIED $name"; problems=$((problems + 1))
      elif [[ -n $(find "$f" -perm -0200) ]]; then
        echo "WRITABLE $name"; problems=$((problems + 1))
      else
        echo "OK $name"; ok=$((ok + 1))
      fi
    fi
  done < "$case_dir/manifest.txt"
  # files that are in the evidence folder but not in the manifest
  while IFS= read -r f; do
    name=${f##*/}
    if [[ -z ${listed[$name]:-} ]]; then
      echo "EXTRA $name"; problems=$((problems + 1))
    fi
  done < <(find "$case_dir/evidence" -type f | LC_ALL=C sort)
  echo "verify: $ok ok, $problems problems"
  if (( problems == 0 )); then
    echo "$now $analyst verify OK" >> "$case_dir/custody.log"
  else
    echo "$now $analyst verify FAILED" >> "$case_dir/custody.log"
    exit 1
  fi
}

[[ $# -ge 1 ]] || usage
case $1 in
  collect)
    [[ $# -ge 5 ]] && is_uint "$4" || usage
    [[ ! -e $2 ]] || { echo "case $2 already exists" >&2; exit 1; }
    collect "${@:2}"
    ;;
  verify)
    [[ $# -eq 4 ]] && is_uint "$4" || usage
    verify "$2" "$3" "$4"
    ;;
  *) usage ;;
esac

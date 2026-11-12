#!/usr/bin/env bash
# Backup verifier: restore the newest backups of each set and compare checksums.
set -euo pipefail

usage() {
  echo "usage: solution.sh [--keep-last N] [--set NAME] BACKUP_DIR" >&2
  exit 3
}

keep=2
only=
while (( $# > 0 )); do
  case $1 in
    --keep-last)
      if [[ ! ${2:-} =~ ^[1-9][0-9]*$ ]]; then
        echo "error: --keep-last needs a positive whole number" >&2
        exit 3
      fi
      keep=$2
      shift 2
      ;;
    --set)
      [[ -n ${2:-} ]] || usage
      only=$2
      shift 2
      ;;
    -*) usage ;;
    *) break ;;
  esac
done
[[ $# -eq 1 ]] || usage
dir=${1%/}
if [[ ! -d $dir ]]; then
  echo "error: cannot read $1" >&2
  exit 3
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Collect "SET|DATE|BASENAME" for every well-named archive, newest first per set.
index=$(
  for archive in "$dir"/*.tar.gz; do
    [[ -f $archive ]] || continue
    base=${archive##*/}
    base=${base%.tar.gz}
    [[ $base =~ ^(.+)-([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]] || continue
    set_name=${BASH_REMATCH[1]}
    [[ -z $only || $only == "$set_name" ]] || continue
    echo "$set_name|${BASH_REMATCH[2]}|$base"
  done | sort -t'|' -k1,1 -k2,2r
)
if [[ -z $index ]]; then
  echo "error: no backups found" >&2
  exit 3
fi

# verify_one BASENAME: returns 0/1 and leaves the explanation in $detail.
detail=
verify_one() {
  local archive=$dir/$1.tar.gz sums=$dir/$1.sums entries bad crc size path f c s p
  local -A listed=()
  local -a missing=() mismatch=() unlisted=() parts=()
  detail=
  if [[ ! -f $sums ]]; then
    detail="no sums file"
    return 1
  fi
  if ! entries=$(tar -tzf "$archive" 2> /dev/null); then
    detail="corrupt archive"
    return 1
  fi
  bad=$(printf '%s\n' "$entries" | grep -E '^/|(^|/)\.\.(/|$)' | head -n 1 || true)
  if [[ -n $bad ]]; then
    detail="unsafe path in archive: $bad"
    return 1
  fi
  rm -rf "$work/restore"
  mkdir "$work/restore"
  if ! tar -xzf "$archive" -C "$work/restore" 2> /dev/null; then
    detail="corrupt archive"
    return 1
  fi

  while read -r crc size path; do
    [[ -n $path ]] || continue
    listed[$path]=1
    f=$work/restore/$path
    if [[ ! -f $f ]]; then
      missing+=("$path")
    else
      read -r c s _ < <(cksum < "$f")
      [[ $c == "$crc" && $s == "$size" ]] || mismatch+=("$path")
    fi
  done < "$sums"
  if (( ${#listed[@]} == 0 )); then
    detail="empty manifest"
    return 1
  fi
  while IFS= read -r p; do
    p=${p#./}
    [[ -n ${listed[$p]:-} ]] || unlisted+=("$p")
  done < <(cd "$work/restore" && find . -type f | sort)

  (( ${#missing[@]} == 0 )) || parts+=("missing: ${missing[*]}")
  (( ${#mismatch[@]} == 0 )) || parts+=("mismatch: ${mismatch[*]}")
  (( ${#unlisted[@]} == 0 )) || parts+=("unlisted: ${unlisted[*]}")
  if (( ${#parts[@]} > 0 )); then
    detail=${parts[0]}
    for p in "${parts[@]:1}"; do detail="$detail; $p"; done
    return 1
  fi
  detail="${#listed[@]} files restored, checksums match"
}

printf '%-6s %-22s %s\n' STATUS BACKUP DETAIL
total_ok=0 total_bad=0 dead_set=0
current=
shown=0 set_ok=0

close_set() {
  [[ -n $current ]] || return 0
  echo "set $current: $set_ok of $shown ok"
  (( set_ok > 0 )) || dead_set=1
}

while IFS='|' read -r set_name _ base; do
  if [[ $set_name != "$current" ]]; then
    close_set
    current=$set_name
    shown=0
    set_ok=0
  fi
  (( shown < keep )) || continue
  shown=$((shown + 1))
  if verify_one "$base"; then
    printf '%-6s %-22s %s\n' OK "$base" "$detail"
    set_ok=$((set_ok + 1))
    total_ok=$((total_ok + 1))
  else
    printf '%-6s %-22s %s\n' FAIL "$base" "$detail"
    total_bad=$((total_bad + 1))
  fi
done <<< "$index"
close_set

echo "verified: $total_ok ok, $total_bad failed"
if (( dead_set )); then exit 2; fi
if (( total_bad > 0 )); then exit 1; fi

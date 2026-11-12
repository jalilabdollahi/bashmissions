#!/usr/bin/env bash
# Audit logger: hash-chained, rotated, anchored, searchable.
set -euo pipefail

usage() {
  echo "usage: solution.sh append ACTOR ACTION DETAIL... | verify [--anchor] | checkpoint | rotate [--max N] | search [--actor A] [--action X] [--from SEQ] [--to SEQ] [--force]" >&2
  exit 2
}

dir=audit
cmd=${1:-}
[[ -n $cmd ]] || usage
shift

ts_re='^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$'
actor_re='^[a-z][a-z0-9_-]*$'
action_re='^[A-Z_]+$'

# checksum PREV SEQ TS ACTOR ACTION DETAIL: the CRC of the exact text, no newline.
checksum() {
  local sum _size
  read -r sum _size < <(printf '%s' "$1|$2|$3|$4|$5|$6" | cksum)
  echo "$sum"
}

segments=()
find_segments() {
  segments=()
  local f
  for f in "$dir"/seg-*.log; do
    [[ -f $f ]] && segments+=("$f")
  done
  if [[ -f $dir/current.log ]]; then segments+=("$dir/current.log"); fi
}

# walk: verify the whole chain across segments.
# Sets entries, seg_count, last_seq, last_sum; on failure sets $bad and returns 1.
entries=0 seg_count=0 last_seq=0 last_sum=0 bad=
walk() {
  local f seq sum ts actor action detail lineno prev=0 expect=1
  find_segments
  entries=0 seg_count=${#segments[@]} bad=
  for f in "${segments[@]}"; do
    lineno=0
    while IFS='|' read -r seq sum ts actor action detail || [[ -n $seq ]]; do
      lineno=$((lineno + 1))
      if [[ ! $seq =~ ^[0-9]+$ || ! $sum =~ ^[0-9]+$ || ! $ts =~ $ts_re || ! $actor =~ $actor_re ||
            ! $action =~ $action_re || -z $detail ]]; then
        bad="${f##*/} line $lineno (bad format)"
        return 1
      fi
      if (( 10#$seq != expect )); then
        bad="${f##*/} line $lineno (sequence gap)"
        return 1
      fi
      if [[ $sum != "$(checksum "$prev" "$seq" "$ts" "$actor" "$action" "$detail")" ]]; then
        bad="${f##*/} line $lineno (checksum mismatch)"
        return 1
      fi
      prev=$sum
      expect=$((expect + 1))
      entries=$((entries + 1))
    done < "$f"
  done
  last_seq=$((expect - 1))
  last_sum=$prev
}

LOCKED=0
lock() {
  mkdir -p "$dir"
  if ! mkdir "$dir/lock" 2> /dev/null; then
    echo "error: audit log is locked by another process" >&2
    exit 4
  fi
  LOCKED=1
  trap 'rmdir "$dir/lock"' EXIT
}

case $cmd in
  append)
    (( $# >= 3 )) || usage
    actor=$1 action=$2
    shift 2
    detail="$*"
    [[ $actor =~ $actor_re && $action =~ $action_re && -n $detail ]] || usage
    lock
    if ! walk; then
      echo "refusing to append: log is tampered" >&2
      exit 1
    fi
    ts=${AUDIT_NOW:-$(date +%Y-%m-%dT%H:%M:%S)}
    seq=$((last_seq + 1))
    sum=$(checksum "$last_sum" "$seq" "$ts" "$actor" "$action" "$detail")
    printf '%s|%s|%s|%s|%s|%s\n' "$seq" "$sum" "$ts" "$actor" "$action" "$detail" >> "$dir/current.log"
    echo "logged #$seq"
    ;;

  verify)
    use_anchor=0
    if [[ ${1:-} == --anchor ]]; then use_anchor=1; shift; fi
    (( $# == 0 )) || usage
    if ! walk; then
      echo "TAMPERED: $bad"
      exit 1
    fi
    if (( ! use_anchor )); then
      echo "OK: $entries entries in $seg_count segments"
      exit 0
    fi
    if [[ ! -f $dir/anchor ]]; then
      echo "NO ANCHOR: run checkpoint first"
      exit 1
    fi
    read -r a_seq a_sum < "$dir/anchor"
    if (( a_seq > last_seq )); then
      echo "TRUNCATED: anchor expects #$a_seq, log ends at #$last_seq"
      exit 1
    fi
    # Find the checksum the log holds for the anchored entry.
    found=$(awk -F'|' -v s="$a_seq" '$1 + 0 == s { print $2; exit }' "${segments[@]}")
    if [[ $found != "$a_sum" ]]; then
      echo "TAMPERED: anchor mismatch at #$a_seq"
      exit 1
    fi
    echo "OK: $entries entries in $seg_count segments"
    echo "anchor OK (#$a_seq)"
    ;;

  checkpoint)
    (( $# == 0 )) || usage
    lock
    if ! walk; then
      echo "refusing to checkpoint: log is tampered" >&2
      exit 1
    fi
    (( entries > 0 )) || { echo "error: nothing to anchor" >&2; exit 1; }
    echo "$last_seq $last_sum" > "$dir/anchor.new"
    mv "$dir/anchor.new" "$dir/anchor"
    echo "anchored #$last_seq"
    ;;

  rotate)
    max=1000
    if [[ ${1:-} == --max ]]; then
      [[ ${2:-} =~ ^[1-9][0-9]*$ ]] || usage
      max=$2
      shift 2
    fi
    (( $# == 0 )) || usage
    lock
    if ! walk; then
      echo "refusing to rotate: log is tampered" >&2
      exit 1
    fi
    n=0
    [[ -f $dir/current.log ]] && n=$(grep -c . "$dir/current.log" || true)
    if (( n < max )); then
      echo "no rotation needed ($n entries)"
      exit 0
    fi
    k=1
    for f in "$dir"/seg-*.log; do
      [[ -f $f ]] && k=$((k + 1))
    done
    printf -v name 'seg-%04d.log' "$k"
    mv "$dir/current.log" "$dir/$name"
    echo "rotated to $name ($n entries)"
    ;;

  search)
    actor= action= from=1 to=999999999 force=0
    while (( $# > 0 )); do
      case $1 in
        --actor) [[ -n ${2:-} ]] || usage; actor=$2; shift 2 ;;
        --action) [[ -n ${2:-} ]] || usage; action=$2; shift 2 ;;
        --from) [[ ${2:-} =~ ^[0-9]+$ ]] || usage; from=$2; shift 2 ;;
        --to) [[ ${2:-} =~ ^[0-9]+$ ]] || usage; to=$2; shift 2 ;;
        --force) force=1; shift ;;
        *) usage ;;
      esac
    done
    if ! walk && (( ! force )); then
      echo "refusing to search: log is tampered" >&2
      exit 1
    fi
    find_segments
    if (( ${#segments[@]} == 0 )); then
      echo "0 matches"
      exit 0
    fi
    cat "${segments[@]}" | awk -F'|' -v a="$actor" -v x="$action" -v lo="$from" -v hi="$to" '
      $1 + 0 >= lo && $1 + 0 <= hi && (a == "" || $4 == a) && (x == "" || $5 == x) {
        d = $6
        for (i = 7; i <= NF; i++) d = d "|" $i
        printf "#%d %s %s %s %s\n", $1, $3, $4, $5, d
        n++
      }
      END { printf "%d matches\n", n }'
    ;;

  *) usage ;;
esac

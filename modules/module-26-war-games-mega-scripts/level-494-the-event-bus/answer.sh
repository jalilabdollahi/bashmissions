#!/usr/bin/env bash
# File-based publish/subscribe bus. The spool directory is the log, each
# subscriber owns a cursor, failures are retried and finally dead-lettered.
set -euo pipefail

usage() {
  echo "usage: solution.sh BUS subscribe PATTERN NAME HANDLER | unsubscribe NAME | publish TOPIC MESSAGE... | dispatch | status" >&2
  exit 2
}

[[ $# -ge 2 ]] || usage
bus=$1 mode=$2
shift 2
[[ -d $bus ]] || { echo "no such bus: $bus" >&2; exit 2; }

spool=$bus/spool subs=$bus/subs cursors=$bus/cursor tries=$bus/tries dead=$bus/dead
max_tries=${MAX_TRIES:-3}
[[ $max_tries =~ ^[1-9][0-9]*$ ]] || max_tries=3

topic_re='^[a-z0-9][a-z0-9._-]*$'
pattern_re='^[a-z0-9*][a-z0-9._*-]*$'
name_re='^[a-z][a-z0-9-]*$'
handler_re='^[A-Za-z0-9_./-]+$'

# last_seq -> highest message number in the spool (0 when empty), as a plain integer
last_seq() {
  local f last=0 n
  for f in "$spool"/*; do
    [[ -f $f ]] || continue
    n=$((10#${f##*/}))
    (( n > last )) && last=$n
  done
  echo "$last"
}

pad() { printf '%06d' "$1"; }

# matches PATTERN TOPIC: glob match (the pattern is deliberately unquoted)
matches() {
  # shellcheck disable=SC2053
  [[ $2 == $1 ]]
}

read_sub() {   # NAME -> sets pattern, handler
  { read -r pattern; read -r handler; } < "$subs/$1"
}

read_cursor() {
  local c=0
  [[ -r $cursors/$1 ]] && c=$(< "$cursors/$1")
  echo "$((10#${c:-0}))"
}

subscriber_names() {
  local f
  for f in "$subs"/*; do
    [[ -f $f ]] && echo "${f##*/}"
  done | LC_ALL=C sort
}

case $mode in
  subscribe)
    [[ $# -eq 3 ]] || usage
    pat=$1 name=$2 hnd=$3
    [[ $pat =~ $pattern_re ]] || { echo "bad pattern '$pat'" >&2; exit 2; }
    [[ $name =~ $name_re ]]   || { echo "bad name '$name'" >&2; exit 2; }
    [[ $hnd =~ $handler_re ]] || { echo "bad handler '$hnd'" >&2; exit 2; }
    mkdir -p "$subs" "$cursors"
    if [[ -e $subs/$name ]]; then
      echo "subscriber $name already exists" >&2
      exit 1
    fi
    cur=$(last_seq)
    printf '%s\n%s\n' "$pat" "$hnd" > "$subs/$name"
    printf '%s\n' "$cur" > "$cursors/$name"
    echo "$name subscribed to $pat (cursor $cur)"
    ;;
  unsubscribe)
    [[ $# -eq 1 ]] || usage
    name=$1
    if [[ ! -f $subs/$name ]]; then
      echo "no such subscriber: $name" >&2
      exit 1
    fi
    rm -f "$bus/subs/$name" "$bus/cursor/$name" "$bus/tries/$name"
    echo "$name unsubscribed"
    ;;
  publish)
    [[ $# -ge 2 ]] || usage
    topic=$1
    shift
    [[ $topic =~ $topic_re ]] || { echo "bad topic '$topic'" >&2; exit 2; }
    text="$*"
    mkdir -p "$spool"
    n=$(( $(last_seq) + 1 ))
    # noclobber makes `>` fail if the file exists: whoever creates it first owns
    # the number, a loser simply tries the next one.
    until ( set -C; printf '%s\n%s\n' "$topic" "$text" > "$spool/$(pad "$n")" ) 2>/dev/null; do
      n=$((n + 1))
    done
    count=0
    for name in $(subscriber_names); do
      read_sub "$name"
      matches "$pattern" "$topic" && count=$((count + 1))
    done
    echo "published #$n to $topic ($count subscribers)"
    ;;
  dispatch)
    [[ $# -eq 0 ]] || usage
    delivered=0 failed=0 deadn=0
    top=$(last_seq)
    for name in $(subscriber_names); do
      read_sub "$name"
      cur=$(read_cursor "$name")
      seq=$((cur + 1))
      while (( seq <= top )); do
        file=$spool/$(pad "$seq")
        if [[ ! -f $file ]]; then
          seq=$((seq + 1)); continue
        fi
        { read -r topic; read -r msg; } < "$file"
        if ! matches "$pattern" "$topic"; then
          printf '%s\n' "$seq" > "$cursors/$name"
          seq=$((seq + 1)); continue
        fi
        if "$handler" "$topic" "$seq" "$msg"; then
          echo "deliver #$seq $topic -> $name ok"
          delivered=$((delivered + 1))
          printf '%s\n' "$seq" > "$cursors/$name"
          rm -f "$bus/tries/$name"
          seq=$((seq + 1))
          continue
        fi
        # failed: bump the attempt counter stored for exactly this message
        attempts=0
        if [[ -r $tries/$name ]]; then
          read -r tseq tcount < "$tries/$name"
          (( tseq == seq )) && attempts=$tcount
        fi
        attempts=$((attempts + 1))
        mkdir -p "$tries"
        printf '%s %s\n' "$seq" "$attempts" > "$tries/$name"
        if (( attempts >= max_tries )); then
          mkdir -p "$dead"
          cp "$file" "$dead/$name.$(pad "$seq")"
          echo "dead-letter #$seq $topic -> $name after $attempts attempts"
          deadn=$((deadn + 1))
          printf '%s\n' "$seq" > "$cursors/$name"
          rm -f "$bus/tries/$name"
          seq=$((seq + 1))
          continue
        fi
        echo "deliver #$seq $topic -> $name failed (attempt $attempts/$max_tries)"
        failed=$((failed + 1))
        break
      done
    done
    echo "dispatch: delivered=$delivered failed=$failed dead=$deadn"
    (( failed == 0 && deadn == 0 ))
    ;;
  status)
    [[ $# -eq 0 ]] || usage
    top=$(last_seq)
    echo "messages: $top"
    names=$(subscriber_names)
    if [[ -z $names ]]; then
      echo "no subscribers"
    else
      for name in $names; do
        read_sub "$name"
        cur=$(read_cursor "$name")
        pending=0
        for (( s = cur + 1; s <= top; s++ )); do
          [[ -f $spool/$(pad "$s") ]] || continue
          { read -r topic; } < "$spool/$(pad "$s")"
          matches "$pattern" "$topic" && pending=$((pending + 1))
        done
        d=0
        for f in "$dead/$name".*; do [[ -f $f ]] && d=$((d + 1)); done
        echo "$name topic=$pattern handler=$handler cursor=$cur pending=$pending dead=$d"
      done
    fi
    ;;
  *) usage ;;
esac

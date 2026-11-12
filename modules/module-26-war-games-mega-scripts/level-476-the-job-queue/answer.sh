#!/usr/bin/env bash
# File-based FIFO job queue with a pool of background workers.
set -euo pipefail

usage() {
  echo "usage: solution.sh submit [--name NAME] COMMAND... | work [--workers N] [--max-tries T] [--limit K] | status | retry ID | log ID" >&2
  exit 2
}

q=queue
cmd=${1:-}
[[ -n $cmd ]] || usage
shift

pos_int() { [[ ${1:-} =~ ^[1-9][0-9]*$ ]] || usage; }

job_field() { sed -n "s/^$2=//p" "$1" | head -n 1; }

case $cmd in
  # ------------------------------------------------------------------ submit
  submit)
    name=
    if [[ ${1:-} == --name ]]; then
      [[ -n ${2:-} ]] || usage
      name=$2
      shift 2
    fi
    (( $# > 0 )) || usage
    command_line="$*"
    [[ -n $name ]] || name=${1##*/}
    mkdir -p "$q/pending"
    n=1
    [[ -f $q/.next ]] && n=$(< "$q/.next")
    printf -v id '%04d' "$n"
    # Written elsewhere first, then moved: a worker never sees half a job.
    tmp=$q/.tmp-$id
    printf 'name=%s\ncmd=%s\n' "$name" "$command_line" > "$tmp"
    mv "$tmp" "$q/pending/$id.job"
    echo $((n + 1)) > "$q/.next"
    echo "submitted $id ($name)"
    ;;

  # -------------------------------------------------------------------- work
  work)
    workers=2 max_tries=2 limit=0
    while (( $# > 0 )); do
      case $1 in
        --workers) pos_int "${2:-}"; workers=$2; shift 2 ;;
        --max-tries) pos_int "${2:-}"; max_tries=$2; shift 2 ;;
        --limit) pos_int "${2:-}"; limit=$2; shift 2 ;;
        *) usage ;;
      esac
    done
    mkdir -p "$q/pending" "$q/done" "$q/failed" "$q/claims"
    if ! mkdir "$q/work.lock" 2> /dev/null; then
      echo "error: another work run is active" >&2
      exit 4
    fi
    work=
    trap 'rmdir "$q/work.lock" 2> /dev/null || true; [[ -z $work ]] || rm -rf "$work"' EXIT

    # orphaned claims: the job is still pending, so the worker that took it died
    for c in "$q"/claims/*; do
      [[ -d $c ]] || continue
      id=${c##*/}
      if [[ -f $q/pending/$id.job ]]; then
        rm -rf "$c"
        echo "recovered job $id"
      fi
    done

    selected=()
    for f in "$q"/pending/*.job; do
      [[ -f $f ]] || continue
      id=${f##*/}
      selected+=("${id%.job}")
      (( limit == 0 || ${#selected[@]} < limit )) || break
    done
    if (( ${#selected[@]} == 0 )); then
      echo "queue is empty"
      exit 0
    fi

    work=$(mktemp -d)

    worker() {
      local id job name command a rc
      for id in "${selected[@]}"; do
        job=$q/pending/$id.job
        # mkdir either creates the claim or fails: that is the whole locking protocol
        mkdir "$q/claims/$id" 2> /dev/null || continue
        # A slow worker can win mkdir for a job that another worker has already finished and
        # released. Look again: if the job has left pending/, give the claim back.
        if [[ ! -f $job ]]; then
          rmdir "$q/claims/$id"
          continue
        fi
        name=$(job_field "$job" name)
        command=$(job_field "$job" cmd)
        rc=0
        for (( a = 1; a <= max_tries; a++ )); do
          rc=0
          bash -c "$command" > "$work/$id.out" 2>&1 || rc=$?
          (( rc != 0 )) || break
          if (( a < max_tries )); then sleep 1; fi
        done
        a=$(( a > max_tries ? max_tries : a ))
        if (( rc == 0 )); then state=done; else state=failed; fi
        mv "$work/$id.out" "$q/$state/$id.out"
        mv "$job" "$q/$state/$id.job"
        rmdir "$q/claims/$id"
        echo "$id $state $name $a $rc" > "$work/$id.result"
      done
    }
    for (( w = 0; w < workers; w++ )); do
      worker &
    done
    wait

    done_n=0 failed_n=0
    for id in "${selected[@]}"; do
      read -r _ state name attempts rc < "$work/$id.result"
      printf '%s %s %s (attempts: %s, exit: %s)\n' "$id" "$state" "$name" "$attempts" "$rc"
      if [[ $state == done ]]; then done_n=$((done_n + 1)); else failed_n=$((failed_n + 1)); fi
    done
    echo "worked: $done_n done, $failed_n failed"
    (( failed_n == 0 )) || exit 1
    ;;

  # ------------------------------------------------------------------ status
  status)
    (( $# == 0 )) || usage
    rows=()
    declare -A count=([pending]=0 [running]=0 [done]=0 [failed]=0)
    for state in pending done failed; do
      for f in "$q/$state"/*.job; do
        [[ -f $f ]] || continue
        id=${f##*/}
        id=${id%.job}
        s=$state
        if [[ $state == pending && -d $q/claims/$id ]]; then s=running; fi
        count[$s]=$((count[$s] + 1))
        rows+=("$id $s $(job_field "$f" name)")
      done
    done
    echo "pending: ${count[pending]}"
    echo "running: ${count[running]}"
    echo "done: ${count[done]}"
    echo "failed: ${count[failed]}"
    printf '%-6s %-8s %s\n' ID STATE NAME
    if (( ${#rows[@]} > 0 )); then
      printf '%s\n' "${rows[@]}" | sort | while read -r id s name; do
        printf '%-6s %-8s %s\n' "$id" "$s" "$name"
      done
    fi
    ;;

  # ------------------------------------------------------------------- retry
  retry)
    (( $# == 1 )) || usage
    id=$1
    if [[ ! -f $q/failed/$id.job ]]; then
      echo "error: no failed job $id" >&2
      exit 3
    fi
    mkdir -p "$q/pending"
    mv "$q/failed/$id.job" "$q/pending/$id.job"
    rm -f "$q/failed/$id.out"
    echo "requeued $id"
    ;;

  # --------------------------------------------------------------------- log
  log)
    (( $# == 1 )) || usage
    id=$1
    for state in done failed; do
      if [[ -f $q/$state/$id.out ]]; then
        cat "$q/$state/$id.out"
        exit 0
      fi
    done
    echo "error: no output for job $id" >&2
    exit 3
    ;;

  *) usage ;;
esac

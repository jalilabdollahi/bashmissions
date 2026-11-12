#!/usr/bin/env bash
set -euo pipefail

usage="usage: solution.sh OSES RUNTIMES [OS/VERSION...]"
list='^[^,]+(,[^,]+)*$'      # one or more items, none of them empty
if (( $# < 2 )) || [[ ! $1 =~ $list ]] || [[ ! $2 =~ $list ]]; then
  echo "$usage" >&2
  exit 2
fi

# IFS=, applies only to this one read; -a stores the pieces in an array.
IFS=, read -ra oses <<< "$1"
IFS=, read -ra runtimes <<< "$2"
shift 2
excluded=" $* "              # remaining arguments, padded so " os/ver " matches whole words

ran=0 passed=0
for os in "${oses[@]}"; do
  for rt in "${runtimes[@]}"; do
    pair="$os/$rt"
    if [[ $excluded == *" $pair "* ]]; then
      echo "[$pair] skipped"
      continue
    fi

    ran=$(( ran + 1 ))
    rc=0
    build-job --os "$os" --runtime "$rt" || rc=$?
    if (( rc == 0 )); then
      passed=$(( passed + 1 ))
      echo "[$pair] ok"
    else
      echo "[$pair] FAILED"
    fi
  done
done

echo "matrix: $passed/$ran passed"
(( passed == ran ))        # exit status 1 when any job failed, 0 otherwise

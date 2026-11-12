#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh HOST..." >&2
  exit 2
fi

results=$(mktemp -d)

# Start all probes at once. Each writes its answer to its own numbered file,
# so jobs finishing in any order cannot mix up their results.
i=0
for host in "$@"; do
  probe-host "$host" > "$results/$i" &
  i=$(( i + 1 ))
done

# Block here until every background job has finished.
wait

# Now report in the order the hosts were given.
i=0
for host in "$@"; do
  echo "$host: $(cat "$results/$i")"
  i=$(( i + 1 ))
done
echo "checked $# hosts"

rm -r "$results"

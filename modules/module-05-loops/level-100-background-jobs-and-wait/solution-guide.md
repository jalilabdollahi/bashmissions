# Walkthrough: Background Jobs and wait

## The plan
Two loops with a `wait` between them. The first loop launches every probe and does not wait for it. The `wait` pauses the script until all probes are finished. The second loop prints the answers in the order the servers were given.

## Step by step
1. Usage check for an empty argument list, exit 2.
2. `results=$(mktemp -d)` makes a private temporary directory. Probes will finish in unpredictable order, so printing from inside the jobs would produce an unpredictable order. Instead, every job stores its answer in a file named after its position.
3. Launch loop: `probe-host "$host" > "$results/$i" &`. The `&` at the end starts the command in the background and the loop continues straight away. After six rounds, six probes are running at the same time.
4. `wait` with no arguments stops the script until every background job has ended. Without it, you would read half-written (empty) files.
5. Report loop: go through the arguments again with a fresh counter and print `"$host: $(cat "$results/$i")"`. The order is now the argument order, whatever finished first.
6. Print `checked $# hosts` and clean up with `rm -r "$results"`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh HOST..." >&2
  exit 2
fi
results=$(mktemp -d)
i=0
for host in "$@"; do
  probe-host "$host" > "$results/$i" &
  i=$(( i + 1 ))
done
wait
i=0
for host in "$@"; do
  echo "$host: $(cat "$results/$i")"
  i=$(( i + 1 ))
done
echo "checked $# hosts"
rm -r "$results"
```

## Trying it by hand
In the workspace the fake probe takes one second. Time the script with `time bash solution.sh a b c d e f`: it should take about one second, not six.

## An alternative
`xargs -P 6` runs a command per input item with parallelism, no loop needed, but then you have to deal with output ordering yourself. For a small fixed number of jobs, `&` and `wait` is the simplest, and it is what `xargs` does under the hood.

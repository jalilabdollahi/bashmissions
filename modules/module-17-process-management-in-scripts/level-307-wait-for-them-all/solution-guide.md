# Walkthrough: Wait for Them All

## The plan

Two phases. In the **start phase** launch every backup and note its PID. In
the **collect phase** wait for each PID in turn and note its status. Only
when both phases are finished do you print anything. That is what makes the
output the same on every run, even though the jobs finish in a different order
every time.

## Step by step

An array remembers the PIDs in the order the jobs were started:

```bash
servers=("$@")
pids=()
for server in "${servers[@]}"; do
  vmbackup "$server" &
  pids+=("$!")
done
```

No `wait` appears inside this loop. If it did, the backups would run one after
another.

Now collect. `wait "$pid"` returns immediately if that job has already
finished, and blocks if it has not. So waiting for the slowest job first does
not lose anything: the others are simply already done when their turn comes.

```bash
statuses=()
for pid in "${pids[@]}"; do
  status=0
  wait "$pid" || status=$?
  statuses+=("$status")
done
```

Index `i` of `statuses` belongs to index `i` of `servers`, so printing in
argument order is a loop over the indexes:

```bash
for i in "${!servers[@]}"; do ... done
```

Count the failures while printing and finish with the summary and the exit
status.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

servers=("$@")
pids=()

# Start phase: nothing is waited for yet, so all backups run together.
for server in "${servers[@]}"; do
  vmbackup "$server" &
  pids+=("$!")
done

# Collect phase: waiting in start order gives results in start order, no
# matter which job actually finished first.
statuses=()
for pid in "${pids[@]}"; do
  status=0
  wait "$pid" || status=$?
  statuses+=("$status")
done

ok=0
failed=0
for i in "${!servers[@]}"; do
  if [[ ${statuses[i]} -eq 0 ]]; then
    echo "${servers[i]} ok"
    ok=$((ok + 1))
  else
    echo "${servers[i]} failed (${statuses[i]})"
    failed=$((failed + 1))
  fi
done

echo "$ok ok, $failed failed"
if [[ $failed -gt 0 ]]; then
  exit 1
fi
```

## Try it by hand

```bash
./solution.sh anchovy barracuda dory eel; echo "exit: $?"
```

Notice that `barracuda` fails after 0.1 s while `anchovy` takes 0.5 s, yet
`anchovy` is still printed first.

## An alternative

`wait -n` returns as soon as *any* job ends, which is useful for reacting
early. But it does not tell you which job it was in older bash versions, so
for "report per server in order" the per-PID wait is simpler and clearer.

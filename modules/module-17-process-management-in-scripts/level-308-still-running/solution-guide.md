# Walkthrough: Still Running?

## The plan

`wait` blocks, and that is not always what you want. A dashboard, a watchdog
or a progress display needs to *look* at a job and carry on. The tool for
looking is `kill -0`: it does not kill anything. Signal number 0 is a
special "no signal": the system checks that the process exists and that you
may signal it, and reports the answer in the exit status.

## Step by step

Start the job and keep its PID:

```bash
reindex &
pid=$!
```

Then a loop with a limited number of rounds. In every round the question is
"is it gone?":

```bash
for ((round = 1; round <= checks; round++)); do
  if ! kill -0 "$pid" 2>/dev/null; then
    echo "reindex finished"
    exit 0
  fi
  sleep 0.1
done
```

`kill -0` succeeds while the process lives, so `! kill -0` is true when it is
gone. The error text printed for a missing process goes to `/dev/null`; the
exit status is all we need. A short `sleep` between looks keeps the script from
burning the CPU in a tight loop (this pattern is called *polling*).

If the loop ends without a `finished`, the job outlived our patience:

```bash
echo "reindex still running after $checks checks"
exit 1
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CHECKS" >&2
  exit 2
fi
checks=$1

reindex &
pid=$!

for ((round = 1; round <= checks; round++)); do
  if ! kill -0 "$pid" 2>/dev/null; then
    echo "reindex finished"
    exit 0
  fi
  sleep 0.1
done

echo "reindex still running after $checks checks"
exit 1
```

## Try it by hand

```bash
REINDEX_SECONDS=1 ./solution.sh 30    # finishes
REINDEX_SECONDS=5 ./solution.sh 3     # gives up
```

## An alternative

`jobs -r` lists the running background jobs of the current shell. It works
only for your own children, while `kill -0` also works on a PID you read from
a pid file written by another program, which is the more common real case.

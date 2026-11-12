# Walkthrough: Run in the Background

## The plan

A script runs one command at a time: it starts a command, waits for it to
finish, then reads the next line. For independent slow jobs that wastes
time. Putting `&` after a command tells the shell "start this, but do not wait
for it". The script moves on immediately and the job runs next to it.

## Step by step

First the argument check, the same shape you used in earlier modules:

```bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh SERVER..." >&2
  exit 2
fi
```

Now the loop. One `&` on the snapshot line is the whole trick:

```bash
for server in "$@"; do
  snapshot "$server" &
done
```

That already runs the snapshots in parallel. But the script has no idea
which process is which. Every time the shell starts a background job it
stores that job's process ID in `$!`. The value is overwritten by the next
background job, so save it straight away:

```bash
  snapshot "$server" &
  echo "$!" >> pids.txt
```

Finally report the count with `$#` and use a plain `wait`, which pauses until
every background child of this script has finished. Without it the script
would end while the snapshots were still running.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh SERVER..." >&2
  exit 2
fi

for server in "$@"; do
  snapshot "$server" &
  echo "$!" >> pids.txt
done

echo "started $# snapshots"
wait
```

## Try it by hand

```bash
./solution.sh anchovy barracuda cuttlefish
cat pids.txt
```

Delete `pids.txt` between runs, because the script appends to it. Try
changing the loop so `&` is missing and notice how the total time grows.

## An alternative

You could put the whole loop body in a function and background the function
call. That is useful when a job needs several commands, but for a single
command the plain `cmd &` is shorter and easier to read.

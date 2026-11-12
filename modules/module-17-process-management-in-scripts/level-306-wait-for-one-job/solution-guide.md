# Walkthrough: Wait for One Job

## The plan

Level 305 started jobs and waited for all of them with a bare `wait`. That
throws information away: you cannot tell which job failed. This time we wait
for one job *by its PID*, and when `wait` returns, its status is the
status of that job.

## Step by step

Start the check and save the PID before anything else can overwrite `$!`:

```bash
integrity-check "$server" &
pid=$!
```

While the check runs, the script is free to do other things. Here it just
prints a line:

```bash
echo "checking $server"
```

Now the interesting part. `wait "$pid"` stops the script until that process
has ended, then returns **the exit status of that process**: 0 for success,
anything else for a failure. If the job was killed by a signal, the status is
128 plus the signal number (you will meet 143 soon).

There is a trap with `set -e`. A non-zero `wait` counts as a failed command,
so the script would end before it prints the verdict. Make the failure
harmless by attaching it to an `||`:

```bash
status=0
wait "$pid" || status=$?
```

Inside the `||` branch `$?` still holds the status that `wait` returned, so
`status` ends up as the real value.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVER" >&2
  exit 2
fi
server=$1

integrity-check "$server" &
pid=$!
echo "checking $server"

status=0
wait "$pid" || status=$?

echo "$server: status $status"
exit "$status"
```

## Try it by hand

```bash
./solution.sh halibut; echo "script exit: $?"
./solution.sh marlin;  echo "script exit: $?"
```

## An alternative

Skip `set -e` for this script and write `wait "$pid"; status=$?`. That is
fine in a tiny script. The `|| status=$?` form keeps working when someone
later adds `set -e` at the top, which is why the answer uses it.

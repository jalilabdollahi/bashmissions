# Walkthrough: Stop a Job

## The plan

Launch the job, give it a time limit, then stop it if it overstays. Stopping
is two moves: **kill** it, and **wait** for it. The kill asks; the wait
confirms it is gone and tells you how it ended.

## Step by step

Start and time-box:

```bash
soaktest &
pid=$!
sleep "$grace"
```

`kill "$pid"` sends SIGTERM, the standard "please shut down" signal. A
well-behaved program cleans up and exits. The command succeeds when the
signal was delivered and fails when no such process exists. That makes it a
perfect test for "was it still running?":

```bash
if kill "$pid" 2>/dev/null; then
  ...it was still running, now stopping...
else
  ...it was already gone...
fi
```

In both branches, `wait "$pid"` collects the job. Its status tells the story:

- killed by SIGTERM: 128 + 15 = **143**
- ended by itself: whatever exit code it chose (0, or 7 in one of the tests)

Under `set -e`, wait's non-zero status would end the script, so use the
`|| status=$?` pattern from earlier. `2>/dev/null` hides the "Terminated"
notice that bash may print for a job killed by a signal.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh GRACE" >&2
  exit 2
fi
grace=$1

soaktest &
pid=$!
sleep "$grace"

if kill "$pid" 2>/dev/null; then
  status=0
  wait "$pid" 2>/dev/null || status=$?
  echo "soaktest stopped (status $status)"
else
  status=0
  wait "$pid" 2>/dev/null || status=$?
  echo "soaktest finished by itself (status $status)"
fi
```

## Try it by hand

```bash
./solution.sh 0.3
SOAK_SECONDS=0.1 ./solution.sh 0.7
```

## An alternative

Use `kill -0` (previous level) first to test, then `kill`. That is two
steps with a tiny gap between them in which the job could end. Letting `kill`
itself report success or failure has no such gap.

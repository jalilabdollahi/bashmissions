# Walkthrough: A Worker Limit

## The plan

We want a *pool*: at most MAX jobs at once, refilled as soon as a seat
becomes free. That needs two things: a counter of running jobs, and a way to
block until the *next* job finishes, whichever it is. `wait -n` is exactly
that.

## Step by step

Take MAX off the argument list so the rest are the image names:

```bash
max=$1
shift
```

A small function books one finished job. `wait -n` returns the status of the
job that ended; we sort it into `ok` or `failed` and free a seat. Putting it in
an `if` keeps `set -e` from ending the script on a failed job.

```bash
reap_one() {
  if wait -n; then ok=$((ok + 1)); else failed=$((failed + 1)); fi
  running=$((running - 1))
}
```

The main loop makes room first, then starts the job:

```bash
for name in "$@"; do
  while (( running >= max )); do reap_one; done
  resize "$name" &
  running=$((running + 1))
done
```

With three seats and eight jobs the first three start at once; the fourth
`resize` starts the moment any of them ends, not when all three do. After the
loop up to MAX jobs are still running, so collect them:

```bash
while (( running > 0 )); do reap_one; done
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh MAX NAME..." >&2
  exit 2
fi
max=$1
shift

running=0
ok=0
failed=0

reap_one() {
  if wait -n; then
    ok=$((ok + 1))
  else
    failed=$((failed + 1))
  fi
  running=$((running - 1))
}

for name in "$@"; do
  while (( running >= max )); do
    reap_one
  done
  resize "$name" &
  running=$((running + 1))
done

while (( running > 0 )); do
  reap_one
done

echo "done: $ok ok, $failed failed"
if (( failed > 0 )); then
  exit 1
fi
```

## Try it by hand

```bash
./solution.sh 3 a.jpg b.jpg c.jpg d.jpg e.jpg corrupt-f.jpg; echo "exit $?"
```

## An alternative

The cheap version is to start MAX jobs, `wait` for all of them, then start
the next batch. It is simpler but wasteful: one slow job holds back the
other MAX - 1 seats. `wait -n` refills each seat the instant it frees.

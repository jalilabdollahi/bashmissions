# Walkthrough: Parallel xargs

## The plan

Level 310 built a worker pool by hand with `wait -n`. `xargs` has one built in.
It reads items, builds a command line for each batch of items and runs
them, with `-P` jobs at the same time. For a list of independent tasks that is
most of what you will ever need.

## Step by step

The basic shape:

```bash
xargs -n 1 -P "$workers" thumb
```

- `-n 1` means one argument per call: `thumb a.png`, `thumb b.png`, ...
  Without it xargs would pack many names into a single call.
- `-P "$workers"` allows that many calls at once, and starts the next the
  moment one ends.

xargs reads the names from standard input; our script's input is passed on
automatically.

Because the thumbnails finish in a different order every time, the combined
output is shuffled. A final `sort` fixes it:

```bash
xargs -n 1 -P "$workers" thumb | sort
```

Now the failure rule. When any call exits with a status from 1 to 125, xargs
finishes the rest of the work and exits with **123**. With `pipefail` on, the
pipeline's status is 123 as well, so under `set -e` the script would stop with
123. The objective wants 1, and the sorted lines printed either way, so test the
pipeline in an `if` and exit 1 yourself:

```bash
if ! xargs -n 1 -P "$workers" thumb | sort; then
  exit 1
fi
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh WORKERS" >&2
  exit 2
fi
workers=$1

if ! xargs -n 1 -P "$workers" thumb | sort; then
  exit 1
fi
```

## Try it by hand

```bash
printf '%s\n' cover-b.png cover-a.png bad-x.png | ./solution.sh 2; echo "exit $?"
```

## An alternative

The hand-made pool from the earlier level gives you per-job control (you
can react to each status). `xargs -P` is shorter and has no counters to get
wrong; it cannot easily tell you *which* job failed except through the
messages the jobs print themselves.

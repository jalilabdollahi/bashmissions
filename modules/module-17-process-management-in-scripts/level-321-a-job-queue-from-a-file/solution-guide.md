# Walkthrough: A Job Queue from a File

## The plan

Three ideas from this module come together: each worker is a background job, the
workers must not overlap their work, and their combined output needs a fixed
order. The queue is a plain text file; the split between workers is simple
arithmetic.

## Step by step

A worker is a function with its own loop over the queue. First it discards what
is not a job: empty lines and `#` comments. Then it numbers the real jobs `n = 0,
1, 2, ...`. Job `n` belongs to the worker whose id equals `n % workers`, so with
three workers worker 0 takes 0, 3, 6; worker 1 takes 1, 4, 7; and so on. Every
worker counts all jobs, theirs and others', so the numbering is the same for
everybody:

```bash
if (( n % workers == id )); then
  if deploy "$job"; then echo "$job ok"; else echo "$job FAILED"; fi
fi
n=$((n + 1))
```

`IFS= read -r job` keeps the whole line as the job name, spaces included, and the
`if deploy "$job"` makes a failing deploy a result instead of a script abort.

Next, starting the workers and gathering their output. The workers print
simultaneously into one pipe; a command group around the start loop and `wait`
lets one `sort` read everything they write, and the command substitution
captures the sorted text:

```bash
results=$(
  {
    for ((id = 0; id < workers; id++)); do
      worker "$id" &
    done
    wait
  } | sort
)
```

Counting happens afterwards, from the collected lines. A worker cannot update
`failed` in the main script (it runs in a child process), but the text it printed
comes back through the pipe.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh WORKERS QUEUE" >&2
  exit 2
fi
workers=$1
queue=$2

if [[ ! -r $queue ]]; then
  echo "cannot read $queue" >&2
  exit 1
fi

worker() {
  local id=$1 n=0 job
  while IFS= read -r job; do
    if [[ -z ${job//[[:space:]]/} || $job == \#* ]]; then
      continue
    fi
    if (( n % workers == id )); then
      if deploy "$job"; then
        echo "$job ok"
      else
        echo "$job FAILED"
      fi
    fi
    n=$((n + 1))
  done < "$queue"
}

results=$(
  {
    for ((id = 0; id < workers; id++)); do
      worker "$id" &
    done
    wait
  } | sort
)

total=0
failed=0
if [[ -n $results ]]; then
  printf '%s\n' "$results"
  total=$(printf '%s\n' "$results" | awk 'END { print NR }')
  failed=$(printf '%s\n' "$results" | awk '/ FAILED$/ { n++ } END { print n + 0 }')
fi

echo "$total jobs, $failed failed"
if (( failed > 0 )); then
  exit 1
fi
```

## Try it by hand

```bash
printf '# list\nalpha\nbeta\ngamma-bad\ndelta\n' > queue.txt
./solution.sh 2 queue.txt; echo "exit $?"
```

## An alternative

A static split by modulo is easy and needs no coordination, but one slow job
can leave its worker busy while another sits idle. A shared queue where each
worker *claims* the next job fixes that; it needs a lock or a pipe, which is
the next level's trick.

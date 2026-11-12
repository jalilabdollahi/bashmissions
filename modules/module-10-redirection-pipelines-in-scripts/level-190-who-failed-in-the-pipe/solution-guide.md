# Walkthrough: Who Failed in the Pipe?

## The plan

Run the pipeline, save the per-stage statuses, print them, and then walk the
list to find the first failure.

## Step by step

After `a | b | c`, the special variable `$?` holds only the status of `c`.
Last Tuesday's archive was empty because `fetch-logs` failed, but `ship-lines`
exited 0, so everything looked fine.

Bash keeps the whole story in the array `PIPESTATUS`: element 0 is stage 1,
element 1 is stage 2, and so on. It is overwritten by every command that
runs afterwards (even `echo`), so copy it on the very next line:

```bash
fetch-logs | scrub-pii | ship-lines
status=("${PIPESTATUS[@]}")
```

Now `status` is yours and will not change. Print it:

```bash
echo "fetch=${status[0]} scrub=${status[1]} ship=${status[2]}"
```

To find the FIRST failure, walk the indexes in order and stop at the first
non-zero entry. A name array turns the index into a readable label:

```bash
names=(fetch-logs scrub-pii ship-lines)
for i in 0 1 2; do
  if (( status[i] != 0 )); then
    echo "pipeline failed at stage $(( i + 1 )) (${names[i]})" >&2
    exit 1
  fi
done
```

## The complete solution

See answer.sh, about fifteen lines.

## Trying it by hand

```bash
SCRUB_RC=3 ./solution.sh; echo "exit=$?"
```

## An alternative

`set -o pipefail` makes the pipeline fail if any stage fails. It is a good
default for scripts, but it cannot tell you WHICH stage or what code, and
`|| true` tricks can hide errors. PIPESTATUS gives you the detail.

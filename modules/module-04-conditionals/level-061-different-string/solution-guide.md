# Walkthrough: Different String?

## The plan

Instead of wrapping the real work in an "if it is dory" block, we turn the logic
inside out: check for the *wrong* host first, refuse loudly, and leave. If the
script gets past the check, the host must be right, and the rest runs unindented.
This pattern is called a guard clause.

## Building it

Store the argument, then ask the negative question with `!=`:

```bash
host="$1"
if [[ $host != dory ]]; then
```

The refusal is an error, so it goes to standard error (`>&2`), not standard
output. That keeps stdout clean for real results, and tools that capture output
will not mistake the complaint for a report:

```bash
  echo "refusing to run on $host: this job belongs to dory" >&2
  exit 1
fi
```

`exit 1` stops the whole script immediately with a failure status, which is how
a calling script or cron learns that the job did not run.

After the `fi`, only dory can be here:

```bash
echo "dory: starting nightly report"
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

host="$1"

if [[ $host != dory ]]; then
  echo "refusing to run on $host: this job belongs to dory" >&2
  exit 1
fi

echo "dory: starting nightly report"
```

## Try it by hand

```bash
./solution.sh dory;      echo "exit=$?"
./solution.sh barracuda; echo "exit=$?"
```

## An alternative

You could write `if [[ $host == dory ]]; then ...work...; else ...refuse...; fi`.
It behaves identically, but all real work sits inside the `if`, and long scripts
become a staircase of indentation. Guards at the top keep the happy path flat.

# Walkthrough: Step Runner

## The plan
A CI pipeline is an ordered list of steps (lint, test, build, deploy). Its core
promise is simple: if a step fails, nothing after it runs, and the whole run
reports the failure. You will build exactly that promise in a loop.

## Step by step
First the guard: with no arguments there is nothing to run.

```bash
if (( $# == 0 )); then
  echo "usage: solution.sh STEP..." >&2
  exit 2
fi
```

Then remember how many steps there are, because `$#` changes meaning inside
functions but not here, and walk the steps with a counter:

```bash
total=$#
n=0
for step in "$@"; do
  n=$(( n + 1 ))
  echo "step $n/$total: $step"
```

Now the interesting part. With `set -e` on, a plain `bash "$step"` that fails
kills your script immediately, so you could not print the "FAILED" line or
choose the exit code. A command on the left of `||` is exempt from `set -e`, so
capture the status there:

```bash
  rc=0
  bash "$step" || rc=$?
```

`rc=0` first makes sure a stale value never survives. Then decide:

```bash
  if (( rc != 0 )); then
    echo "FAILED at step $n: $step (exit $rc)" >&2
    exit "$rc"
  fi
done
echo "pipeline passed: $total step(s)"
```

A step file that does not exist makes `bash` itself exit 127, so a missing
step fails the pipeline naturally.

## Try it by hand
```bash
echo 'exit 4' > bad.sh; echo 'echo hi' > ok.sh
./solution.sh ok.sh bad.sh ok.sh; echo "pipeline exit: $?"
```

## Alternative
You could drop `set -e` and write `bash "$step" || { ...; exit $?; }`, but
inside the braces `$?` is already the status of the failed step only if you read
it first. Keeping `set -e` on for the rest of the script and handling this one
expected failure explicitly is the safer habit for pipeline code.

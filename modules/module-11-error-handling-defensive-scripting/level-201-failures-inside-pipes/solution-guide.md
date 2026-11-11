# Walkthrough: Failures Inside Pipes

## The plan
The pipeline and the `if` around it are already right. What is wrong is the
status Bash computes for `a | b | c`. We change one setting and keep the rest.

## What happens today
In `fetchlog SITE | sort -u > summary.txt` the two commands run side by side.
`fetchlog` prints two lines, hits the "connection reset" and exits with status 1.
`sort` sees end-of-input like any normal ending, sorts what it received and
exits 0. By default the pipeline's status is the status of the last command, so
the `if` sees 0 and cheerfully reports a summary built from half the log.

You can see this at the prompt:

```bash
false | true; echo $?     # prints 0
```

## The fix
```bash
set -o pipefail
```

With pipefail on, the status of a pipeline becomes the status of the right-most
command that failed, or 0 if every stage succeeded. The same experiment now
prints 1, and our `if` takes the else branch: message on stderr, exit 3.

## Complete solution
```bash
#!/usr/bin/env bash
set -o pipefail

if fetchlog "$1" | sort -u > summary.txt; then
  echo "summary ready: $(( $(wc -l < summary.txt) )) distinct lines"
else
  echo "fetch failed for $1" >&2
  exit 3
fi
```

## Try it by hand
```bash
./solution.sh harbour-bakery
FAKE_FETCH_FAIL=1 ./solution.sh harbour-bakery; echo "exit=$?"
```

## Alternative
Without pipefail you can read `${PIPESTATUS[@]}` right after the pipeline: it is
an array with every stage's status. That is useful when you need to know *which*
stage failed, but the single option is shorter and protects every pipeline in
the script, including ones you add later.

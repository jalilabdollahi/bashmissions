# Walkthrough: if and else

## The plan

Noor needs an answer in both cases, so the script must have two outcomes. We
need a yes/no question ("does the log contain ERROR?") and two `echo` lines, one
for each answer.

## Building it

The question is easy to forget how to ask. You do not need `[[ ]]` here: `if`
accepts any command and reacts to whether it succeeded. `grep -q` is perfect,
because `-q` (quiet) prints nothing and just reports found or not found:

```bash
if grep -q 'ERROR' "$logfile"; then
```

The `then` branch handles "found". Add `else` for everything else:

```bash
  echo "needs attention: ERROR found in $logfile"
else
  echo "clean: no ERROR in $logfile"
fi
```

Exactly one of the two branches runs, never both and never neither. That is what
makes `else` different from two separate `if` blocks.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

logfile="$1"

if grep -q 'ERROR' "$logfile"; then
  echo "needs attention: ERROR found in $logfile"
else
  echo "clean: no ERROR in $logfile"
fi
```

## Try it by hand

```bash
printf 'INFO ok\nERROR boom\n' > demo.log
./solution.sh demo.log
echo 'all fine' > calm.log
./solution.sh calm.log
```

## An alternative

You could run grep first, then inspect `$?` with `[[ $? -eq 0 ]]`. It works, but
it is longer and easy to break: any command placed in between overwrites `$?`.
Putting the command directly in the `if` is the idiom everyone recognises.

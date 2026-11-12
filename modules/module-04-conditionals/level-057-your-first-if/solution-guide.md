# Walkthrough: Your First if

## The plan

The script has to make a decision: print a warning or stay quiet. In Bash, a
decision is an `if` block. It asks a question; if the answer is "yes" it runs
the lines between `then` and `fi`, and if the answer is "no" it skips them.

## Building it

First, keep the argument in a named variable so the script reads well:

```bash
target="${1:-}"
```

The `:-` part means "use an empty string if there is no `$1`". Without it, a
script that runs with `set -u` would crash when started with no arguments.

Next, the question. Double brackets are Bash's test command, and `==` asks
"are these two strings identical?":

```bash
if [[ $target == prod ]]; then
```

Finally, the body and the closing word:

```bash
  echo "CAUTION: production - the two-person rule applies"
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

target="${1:-}"

if [[ $target == prod ]]; then
  echo "CAUTION: production - the two-person rule applies"
fi
```

## Try it by hand

```bash
./solution.sh prod        # prints the warning
./solution.sh staging     # prints nothing
./solution.sh ""          # prints nothing
```

## An alternative

You could write the shorter `[[ $target == prod ]] && echo "CAUTION..."`.
It works for this tiny job, but a real `if` block is easier to extend later
(you will add an else branch in the very next level) and reads like the
runbook sentence it came from. Level 75 covers the one-liner style and its trap.

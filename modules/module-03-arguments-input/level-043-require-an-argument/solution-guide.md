# Walkthrough: Require an Argument

## The plan
Two behaviours: the normal one, and a polite refusal. The refusal has three
parts, all of which the tests check: say how to use the script, say it on stderr,
and exit with status 2.

## Building it
The normal path is one line:

```bash
echo "Looking up customer: $1"
```

Before it, a guard. `[[ $# -lt 1 ]]` tests "fewer than one argument" (`-lt` is
"less than"). `&&` means "and then run this only if the test succeeded". The
braces group the two commands that run when the test is true:

```bash
[[ $# -lt 1 ]] && { echo "usage: solution.sh CUSTOMER" >&2; exit 2; }
```

`>&2` redirects the echo to stderr, so a script that captures stdout does not
receive the error text as data. `exit 2` stops everything below the guard from
running.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
[[ $# -lt 1 ]] && { echo "usage: solution.sh CUSTOMER" >&2; exit 2; }
echo "Looking up customer: $1"
```

## Try it by hand
```bash
./solution.sh "Harbour Bakery"
./solution.sh; echo "status=$?"
./solution.sh 2>/dev/null; echo "status=$?"    # usage text hidden: it was on stderr
```

## Alternative
Module 4 teaches `if`, which reads more clearly for longer checks. The `&&`
guard is the shortest form and a common idiom at the top of scripts. Without the
check, `set -u` would still stop the script on the missing `$1`, but with a
cryptic `unbound variable` message and exit status 1.

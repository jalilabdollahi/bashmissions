# Walkthrough: Does the Function Exist?

## The plan

Build the function name from each argument, ask Bash whether it is a function,
and call it only if it is. Collect "something was skipped" in a variable so the
final exit code can say so.

## Step by step

The three checks are plain functions at the top of the script. Then the loop:

```bash
skipped=0
for name in "$@"; do
```

`declare -F "check_$name"` is the question. With a name it prints the name
and succeeds if the function exists, or prints nothing and fails if not. The
printed name is noise here, so discard it; the status is the answer:

```bash
  if declare -F "check_$name" > /dev/null; then
    "check_$name"
  else
    echo "skip: no check named $name" >&2
    skipped=1
  fi
done
exit "$skipped"
```

Used as the condition of an `if`, a failing command does not trigger
`set -e`; that is exactly what an `if` is for.

## Why not another test?

- `[[ -v check_backup ]]` asks about a *variable*. The test sets one with that
  very name, and it would claim a function exists.
- `command -v check_pier` also finds programs on the PATH. The test provides
  a stub program called `check_pier`; the function test must not see it.
- `type check_NAME` is noisy and finds aliases and builtins too.

`declare -F` looks at one table only, the table of shell functions, which is
exactly the question.

## Try it by hand

```
./solution.sh disk mail
./solution.sh disk dsik cert; echo "exit=$?"
check_backup=yes ./solution.sh backup
```

## Alternative

`[[ $(type -t "check_$name") == function ]]` gives the same answer in one
expression, at the price of a subshell and a harder-to-read condition.
`declare -F` reads best.

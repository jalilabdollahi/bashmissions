# Walkthrough: Is the Tool Installed?

## The plan

A script that depends on an external program should check for it up front and
fail with a clear message instead of crashing in the middle. The question "can
Bash find this command?" has a built-in answer: `command -v`.

## Building it

Handle the usage error first. `$#` counts the arguments:

```bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh TOOL" >&2
  exit 2
fi
tool="$1"
```

Now ask the question. `command -v name` prints how Bash would resolve the name
(a path, an alias, a function) and succeeds if it exists; otherwise it prints
nothing and fails. We only want the verdict, so discard the output:

```bash
if command -v "$tool" >/dev/null 2>&1; then
```

If the tool exists, run it with `--version` and show the result. `$( ... )`
captures the output of a command inside the string:

```bash
  echo "found: $("$tool" --version)"
else
  echo "missing: $tool" >&2
  exit 1
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh TOOL" >&2
  exit 2
fi

tool="$1"

if command -v "$tool" >/dev/null 2>&1; then
  echo "found: $("$tool" --version)"
else
  echo "missing: $tool" >&2
  exit 1
fi
```

## Try it by hand

```bash
./solution.sh bash
./solution.sh no-such-tool; echo "exit=$?"
```

## An alternative

`which tool` looks like the same thing, but it is an external program that behaves
differently on different systems: some versions print nothing, others print an
error message, and a few always exit 0. `command -v` is part of the POSIX
shell standard and behaves the same everywhere.

# Debrief: Decorators

A decorator adds behaviour *around* a function without changing the function
or its callers. The shape is always the same: do something before, call the
original with every argument, do something after, hand back the original's
result. Here the extras were a trace line, but the same skeleton carries
timing, logging, retries and permission checks, all of which are the next levels.

## Under the hood

Functions in Bash live in a table that maps names to bodies. `declare -f`
reads an entry back as source text; `eval` writes text back as an entry. By
reading the old body and writing it under `orig_NAME`, you free the original
name for the wrapper while the original code stays callable. Nothing is
copied lazily: the wrapper holds a *call by name*, so redefining `orig_NAME`
later changes what the wrapper runs.

Two details protect the contract. The wrapper forwards `"$@"` untouched, so
arguments with spaces survive. And it returns the original's status, so
callers' `if restart_service ...` keeps working. Capturing a status that might
be non-zero needs `|| rc=$?` under `set -e`.

## In real work

Nobody wants to edit ten vendored functions to add tracing. Wrapping them at
load time is how test doubles, profilers and audit layers get in.

## Going further

Before you wrap something it helps to know it exists, and to know *what kind
of thing* a name is. Next: `declare -F`.

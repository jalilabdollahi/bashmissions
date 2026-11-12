# Walkthrough: Append to a File

## The plan

Each argument becomes one line. The only real question is how to write a line
at the end of a file without destroying what is already there.

## Step by step

`>` opens a file for writing and truncates it. `>>` opens it for writing but
positions every write at the end, and creates the file if needed. So the core
of the script is a loop with `>>` inside it.

```bash
for event in "$@"; do
  printf '[audit] %s\n' "$event" >> audit.log
done
```

Why `printf` and not `echo`? An event like `deleted *.tmp; ok?` is just text.
With `printf '%s\n'` the text is passed through untouched. (`echo` would also
work for these tests, but it can swallow things such as a leading `-n`.)

The loop also solves the "no arguments" case for free: when `"$@"` is empty,
the body never runs, so audit.log is never opened and keeps its content.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
for event in "$@"; do
  printf '[audit] %s\n' "$event" >> audit.log
done
```

## Trying it by hand

```bash
./solution.sh "logged in to anchovy"
./solution.sh "restarted nginx on eel" "rotated keys on dory"
cat audit.log     # three lines, in order
```

## An alternative

You could open the file once for the whole loop by putting the redirect after
`done`:

```bash
for event in "$@"; do printf '[audit] %s\n' "$event"; done >> audit.log
```

That is neat, but with zero arguments the shell still opens (and may create)
the file. The per-line version leaves the file untouched, which matters for an
audit log.

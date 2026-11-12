# Walkthrough: Named Pipes

## The plan

A normal pipe (`a | b`) connects two commands that the shell starts together.
A **named pipe**, or FIFO, is the same plumbing with a name in the file system,
so two programs started separately can still be connected, as long as they
agree on the name. Here `tailfeed` is the writer and our script is the reader.

## Step by step

Create the pipe. `ls -l` would show it with a `p` in the first column:

```bash
mkfifo feed.pipe
```

Start the writer in the background. This is not optional: opening a FIFO
blocks until somebody has opened the other end, so a foreground writer
would wait for a reader that cannot start until the writer returns. The
writer and the reader must run side by side.

```bash
tailfeed "$src" feed.pipe &
pid=$!
```

Now read. Putting `< feed.pipe` on the `done` keeps the loop in the main
shell, so the counter survives. (With `cat feed.pipe | while ...` the loop would
run in a subshell, and `errors` would be 0 afterwards.)

```bash
while IFS= read -r line; do
  if [[ $line == *ERROR* ]]; then
    echo "!! $line"
    errors=$((errors + 1))
  fi
done < feed.pipe
```

`IFS= read -r` keeps leading spaces and backslashes exactly as they came. The
loop stops when the writer closes its end: that is end-of-file for a pipe.

Finally collect the writer's status with `wait "$pid"`, remove the pipe like any
file with `rm`, and exit with that status.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SRC" >&2
  exit 2
fi
src=$1

mkfifo feed.pipe
tailfeed "$src" feed.pipe &
pid=$!

errors=0
while IFS= read -r line; do
  if [[ $line == *ERROR* ]]; then
    echo "!! $line"
    errors=$((errors + 1))
  fi
done < feed.pipe

echo "errors=$errors"

status=0
wait "$pid" 2>/dev/null || status=$?
rm feed.pipe
exit "$status"
```

## Try it by hand

```bash
printf 'INFO a\nERROR b\n' > web.log
./solution.sh web.log
ls feed.pipe   # gone
```

If your script hangs, press Ctrl-C and run `rm -f feed.pipe`: one side of the
pipe never got a partner.

## An alternative

A plain pipe `tailfeed ... | while read ...` needs no name, but the loop then
runs in a subshell and `tailfeed` must write to stdout. A FIFO lets unrelated
programs connect and lets you keep the loop in the main shell.

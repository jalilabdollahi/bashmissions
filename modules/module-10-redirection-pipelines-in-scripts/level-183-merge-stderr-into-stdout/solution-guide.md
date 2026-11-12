# Walkthrough: Merge stderr into stdout

## The plan

Put stdout in a file, then make stderr follow it. Then report the tool's exit
status without letting a failure end our own script.

## Step by step

Think of the descriptor table. At start: `1 -> terminal`, `2 -> terminal`.

The shell reads redirections left to right and applies each one immediately:

```bash
sync-tool "$target" > sync.log 2>&1
```

- `> sync.log`: slot 1 now points at the file.
- `2>&1`: slot 2 becomes a copy of slot 1, so it points at the file too.

Both streams land in the file. Now the wrong order:

```bash
sync-tool "$target" 2>&1 > sync.log
```

- `2>&1` first: slot 2 copies slot 1, which still points at the terminal.
- `> sync.log`: slot 1 moves to the file, but slot 2 stays on the terminal.

The error line then appears on screen. That is what bit Ollie, and what the
tests check with an empty expected stderr.

For the exit status, the tool may fail, so we do not use `set -e` here.
Initialise `status=0` and capture failures with `|| status=$?`.

## The complete solution

```bash
#!/usr/bin/env bash
target=$1
status=0
sync-tool "$target" > sync.log 2>&1 || status=$?
echo "sync exit status: $status"
```

## Trying it by hand

```bash
SYNC_RC=4 ./solution.sh octopus
cat sync.log
```

Then swap the order of the two redirections and watch the error line escape
to the screen.

## An alternative

`&> sync.log` does the same in Bash in one token. We avoid it here because
`> file 2>&1` is the form you will see in nearly every real script, including
ones for `sh`.

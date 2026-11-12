# Walkthrough: Subshell Isolation

## The plan

The environment of one command should be special, and everything after it
should be normal again. Instead of setting a variable and carefully undoing
it later, run the special part in a **subshell**: a child copy of your shell,
created by parentheses. When it ends, all its changes end with it.

## Step by step

First the top of the script. `LOG_LEVEL` is exported, so programs started from
this script (like `probe`) can read it:

```bash
label=$1
LOG_LEVEL=info
export LOG_LEVEL
```

Now the subshell. The child starts as an exact copy of the parent, with the
same variables, so `$label` is available inside. It then changes its own copy:

```bash
(
  export LOG_LEVEL=debug
  export PROBE_LABEL=$label
  probe
  exit 7
)
```

`probe` sees `debug` and the label. The `exit 7` does not end the script. It only
ends the subshell, which then reports status 7 to its parent.

That status is non-zero, so under `set -e` it would end the script. Attach
`|| status=$?` to the closing parenthesis and the failure becomes a value:

```bash
status=0
( ... ) || status=$?
echo "subshell exited with $status"
```

Finally, the proof of isolation: a second `probe` in the main shell prints
`level=info label=none`, and `$LOG_LEVEL` is still `info`.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LABEL" >&2
  exit 2
fi
label=$1

LOG_LEVEL=info
export LOG_LEVEL

# Everything between ( and ) runs in a copy of this shell. Changes to
# variables, and the exit 7, only affect that copy.
status=0
(
  export LOG_LEVEL=debug
  export PROBE_LABEL=$label
  probe
  exit 7
) || status=$?
echo "subshell exited with $status"

# Back in the original shell: nothing changed.
probe
echo "main LOG_LEVEL=$LOG_LEVEL"
```

## Try it by hand

```bash
./solution.sh "night shift"
```

Then type `x=1; ( x=2 ); echo $x` in a terminal and predict the output.

## An alternative

A one-command version needs no subshell: `LOG_LEVEL=debug probe` sets the
variable only for that single command. The subshell is better when several
commands share the temporary environment.

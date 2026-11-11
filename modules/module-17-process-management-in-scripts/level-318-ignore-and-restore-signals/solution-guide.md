# Walkthrough: Ignore and Restore Signals

## The plan

Three states exist for any signal: the **default** action (for TERM:
terminate), a **handler** you installed, and **ignored**. You move between them
with `trap`. This level goes default, then ignored, then back to default.

## Step by step

An *empty* command string means "ignore":

```bash
trap '' TERM
kill -TERM $$
echo "shielded $name"
```

The `kill` sends TERM to the script itself, and nothing happens: the kernel
delivers the signal, the shell discards it. With the default action this very
line would end the script, so surviving is the proof that the shield works.

Now start a child. When a program is started with a signal ignored, it
**starts out ignoring it too**: the ignored state survives `fork` and `exec`. The
worker's `kill -TERM $$` therefore does nothing and it prints its message:

```bash
status=0
worker || status=$?
echo "phase 1 ($name): status $status"
```

(`|| status=$?` again keeps a failure from stopping a `set -e` script.)

Now take the shield down. `trap -` followed by the signal name restores the
default action:

```bash
trap - TERM
```

The second worker is not protected any more. Its own TERM kills it before
it can print anything, and the shell reports the status 128 + 15 = 143.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1

trap '' TERM
kill -TERM $$
echo "shielded $name"

status=0
worker || status=$?
echo "phase 1 ($name): status $status"

trap - TERM

status=0
worker || status=$?
echo "phase 2 ($name): status $status"
```

## Try it by hand

```bash
./solution.sh nightly
```

You will probably see a line like `Terminated: 15 ... worker` on stderr from
phase 2: that is bash announcing that a child died from a signal.

## An alternative

`trap 'echo ignoring' TERM` installs a *handler* instead. The script survives
too, but children then get the **default** action back, so the worker would die.
Ignoring (`''`) is the only form that protects the programs you start.

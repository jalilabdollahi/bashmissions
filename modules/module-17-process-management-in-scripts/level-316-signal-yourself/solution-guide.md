# Walkthrough: Signal Yourself

## The plan

Daemons are controlled from outside: you send a signal and the program reacts.
To test that without a second terminal, the script sends signals to itself.
So there are two halves: **handlers** (what to do when a signal arrives) and
**senders** (`kill -SIGNAL $$`).

## Step by step

State first, then the two handlers. They are ordinary functions:

```bash
verbose=off
steps=0

on_usr1() {
  if [[ $verbose == off ]]; then verbose=on; else verbose=off; fi
  echo "verbose is now $verbose"
}
on_usr2() {
  echo "status: $steps steps, verbose=$verbose"
}
```

`trap` connects a signal to a handler. This must happen before the first
signal is sent, because the default action of USR1 and USR2 is to end the
process:

```bash
trap on_usr1 USR1
trap on_usr2 USR2
```

The handlers run in the *main* shell, between two of your commands, so they can
read and change `verbose` and `steps`.

Now the actions. `go` is plain counting. `verbose` and `status` are the signals
being sent. `$$` is the script's own PID:

```bash
verbose) kill -USR1 $$ ;;
status)  kill -USR2 $$ ;;
```

`kill` is a shell builtin, so bash delivers the signal to itself and runs the
handler as soon as the `kill` command is done, before the next action starts.
That makes the output order predictable.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh ACTION..." >&2
  exit 2
fi

verbose=off
steps=0

on_usr1() {
  if [[ $verbose == off ]]; then verbose=on; else verbose=off; fi
  echo "verbose is now $verbose"
}

on_usr2() {
  echo "status: $steps steps, verbose=$verbose"
}

trap on_usr1 USR1
trap on_usr2 USR2

for action in "$@"; do
  case $action in
    go)
      steps=$((steps + 1))
      if [[ $verbose == on ]]; then
        echo "step $steps"
      fi
      ;;
    verbose) kill -USR1 $$ ;;
    status)  kill -USR2 $$ ;;
    *)
      echo "unknown command: $action" >&2
      exit 2
      ;;
  esac
done
```

## Try it by hand

```bash
./solution.sh go verbose go go status
```

In a second terminal you could do the real thing: run a long script, then
`kill -USR2 <its pid>`.

## An alternative

Instead of a named function you can give `trap` a quoted command:
`trap 'echo status' USR2`. A function is easier once the handler has more than
one line.

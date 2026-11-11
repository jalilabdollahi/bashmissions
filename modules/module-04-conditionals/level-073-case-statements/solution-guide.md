# Walkthrough: case Statements

## The plan

One word comes in (`start`, `stop`, ...) and each possible word has its own
reaction. That is a menu, and Bash's `case` statement is a menu: it names the
value once and lists the possibilities under it. Compared with an `elif` ladder
you stop repeating `[[ $action == ... ]]` on every rung.

## Anatomy of a case

```bash
case "$action" in
  start)
    echo "lanternd: starting"
    ;;
```

- `case "$action" in` says which word to look at.
- `start)` is a pattern; the closing parenthesis ends it.
- The commands follow, and `;;` ends the branch (think "that's all for this one").
- `esac` closes the whole thing.

## Building it

Read the action in a way that survives a missing argument, then list the four
known actions:

```bash
action="${1:-}"
case "$action" in
  start)   echo "lanternd: starting" ;;
  stop)    echo "lanternd: stopping" ;;
  restart) echo "lanternd: restarting" ;;
  status)  echo "lanternd: running (pid 4242)" ;;
```

The final branch uses the pattern `*`, which matches anything. Bash checks
branches top to bottom and stops at the first match, so `*)` must be last or it
would swallow everything:

```bash
  *)
    echo "usage: solution.sh start|stop|restart|status" >&2
    exit 2
    ;;
esac
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"

case "$action" in
  start)
    echo "lanternd: starting"
    ;;
  stop)
    echo "lanternd: stopping"
    ;;
  restart)
    echo "lanternd: restarting"
    ;;
  status)
    echo "lanternd: running (pid 4242)"
    ;;
  *)
    echo "usage: solution.sh start|stop|restart|status" >&2
    exit 2
    ;;
esac
```

## Try it by hand

```bash
./solution.sh start
./solution.sh bogus; echo "exit=$?"
```

## An alternative

The same program as an if/elif ladder is correct but longer, and the variable
name repeats on every rung. Use `case` whenever one value is matched against
several fixed options.

# Walkthrough: Increment and Decrement

## The plan

Two variables start at zero. We read the log line by line; each line starts with
a word that tells us the event. A `connect` bumps both counters, a `disconnect`
lowers one. Every other line falls through and is ignored.

## Building it

Counters first. Initialising them matters: `echo "$total"` on an unset variable
would be an error under `set -u`.

```bash
total=0
active=0
```

Reading the log. `read -r event user` splits each line on spaces: the first word
goes into `event`, the rest into `user`.

```bash
while read -r event user; do
  ...
done
```

Inside, a `case` picks the action. `(( total++ ))` is the short way to write
`total=$(( total + 1 ))`:

```bash
case "$event" in
  connect)    (( total++ )); (( active++ )) ;;
  disconnect) (( active-- )) ;;
esac
```

## A surprise worth knowing

`(( x++ ))` is a command, and like every command it has an exit status. In `(( ))`
the status is 0 (success) when the expression is nonzero and 1 (failure) when
it is zero. `x++` evaluates to the value from before the increment, so the first
`(( total++ ))` evaluates to 0, which means status 1. With `set -e` that would
stop the script on the very first connect. That is why this solution leaves
`-e` off and says so in a comment.

## Complete solution

```bash
#!/usr/bin/env bash
set -uo pipefail

total=0
active=0

while read -r event user; do
  case "$event" in
    connect)    (( total++ )); (( active++ )) ;;
    disconnect) (( active-- )) ;;
  esac
done

echo "total_connects=$total"
echo "still_connected=$active"
```

## Try it by hand

```bash
printf 'connect ana\nconnect tom\ndisconnect ana\n' | ./solution.sh
```

## An alternative

`total=$(( total + 1 ))` is a plain assignment: its exit status is always 0, so
it is safe with `set -e`. It is longer, though. If you want the short form and
`-e` together, write `(( total++ )) || true`.

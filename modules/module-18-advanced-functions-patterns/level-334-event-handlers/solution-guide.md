# Walkthrough: Event Handlers

## The plan

Two operations, `on` (subscribe) and `emit` (publish), share one data
structure: a map from event name to the list of functions that subscribed.
The sender of an event never learns who is listening.

## Step by step

The registry is an associative array whose values are space-separated lists
of function names:

```bash
declare -A handlers=()
problems=0
```

`on` refuses names that are not functions, then appends. The expansion
`${handlers[$event]:+ }` produces a space only when the entry already has
text, which avoids a leading blank:

```bash
on() {
  local event=$1 fn=$2
  if ! declare -F "$fn" > /dev/null; then
    echo "on: no such handler '$fn'" >&2
    problems=1
    return 0
  fi
  handlers[$event]+="${handlers[$event]:+ }$fn"
}
```

`emit` takes the event name off with `shift`, so `"$@"` is the payload. The
registered names are split by the unquoted `for fn in ${handlers[$event]}`:
that is fine because function names we registered never contain spaces or
glob characters. The payload stays quoted:

```bash
emit() {
  local event=$1 fn
  shift
  if [[ -z ${handlers[$event]:-} ]]; then
    echo "emit: nobody listens to '$event'" >&2
    problems=1
    return 0
  fi
  for fn in ${handlers[$event]}; do "$fn" "$@"; done
}
```

The main loop parses a line into an array so the payload keeps its words, and
`${words[@]:2}` is "from the third word on". A `case` picks `on`, `emit` or
the error branch, and the exit status is the `problems` flag.

## Try it by hand

```
printf 'on deploy h_log\non deploy h_mail\nemit deploy bakery v2\n' | ./solution.sh
```

## Alternative

You could store handlers in one indexed array per event, but the number of
events is not known in advance, and an associative array of strings is the
simplest dynamic structure in Bash. With a pure array version you need
nameref variables, a topic from module 6 that adds complexity without
adding anything here.

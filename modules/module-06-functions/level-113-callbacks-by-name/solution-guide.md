# Walkthrough: Callbacks by Name

## The plan
Split the work in two: *how to loop* (apply_each, written once) and *what to do
per item* (the callback, chosen at run time).

## Building it
The loop helper takes the callback's name first and the items after it. `shift`
removes the first argument so that `"$@"` holds only the items:

```bash
apply_each() {
  local callback=$1 item
  shift
  for item in "$@"; do
    "$callback" "$item"
  done
}
```

`"$callback" "$item"` is the key line. Bash expands the variable into
`upper_line` and then runs that function with the item as its argument.

The dispatch maps the user's MODE word onto a function name. Shift the mode away
first (but only if there was one, because `shift` with no arguments fails under
`set -e`), so the remaining arguments are the items:

```bash
mode=${1:-}
[[ $# -gt 0 ]] && shift
case $mode in
  upper)  apply_each upper_line "$@" ;;
  length) apply_each length_line "$@" ;;
  *)      echo "unknown mode: $mode" >&2; exit 2 ;;
esac
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

upper_line() {
  echo "${1^^}"
}

length_line() {
  echo "$1: ${#1}"
}

# apply_each CALLBACK ITEM...
# A function name is just a word. Stored in a variable it can be called later.
apply_each() {
  local callback=$1 item
  shift                          # drop the callback; "$@" is now only the items
  for item in "$@"; do
    "$callback" "$item"          # run whichever function was named
  done
}

mode=${1:-}
[[ $# -gt 0 ]] && shift
case $mode in
  upper)  apply_each upper_line "$@" ;;
  length) apply_each length_line "$@" ;;
  *)      echo "unknown mode: $mode" >&2; exit 2 ;;
esac
```

## Try it by hand
```bash
./solution.sh upper dory eel
./solution.sh length anchovy ok
./solution.sh reverse dory; echo "status $?"
```

## Alternative
Without callbacks you would copy the loop into every branch of the `case`. It works
for two modes and becomes a maintenance burden at ten. Passing the function name
keeps the loop in one place, and adding a mode means adding one worker and one
case line.

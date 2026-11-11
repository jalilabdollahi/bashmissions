# Walkthrough: Guard Clauses

## The plan
List everything that can go wrong, in the order it should be noticed, and handle
each one at the top of the function with an early `return`. The good path is the
last thing in the function and has no indentation.

## Building it
Copy the arguments to named locals with defaults so missing ones are safe:

```bash
local name=${1:-} gb=${2:-}
```

Guard 1: nothing to name.

```bash
if [[ -z $name ]]; then
  echo "error: name required" >&2
  return 2
fi
```

Guard 2: the size must be digits only, before any arithmetic touches it. The
`=~` operator matches a regular expression:

```bash
if ! [[ $gb =~ ^[0-9]+$ ]]; then
  echo "error: GB must be a number" >&2
  return 3
fi
```

Guard 3: now it is safe to compare as a number:

```bash
if (( gb < 1 || gb > 100 )); then
  echo "error: GB must be 1-100" >&2
  return 4
fi
```

The order matters: testing `gb < 1` on the word `twenty` would be wrong. Finally
the real work, flat at the bottom.

## Complete solution
```bash
#!/usr/bin/env bash
set_quota() {
  local name=${1:-} gb=${2:-}
  if [[ -z $name ]]; then echo "error: name required" >&2; return 2; fi
  if ! [[ $gb =~ ^[0-9]+$ ]]; then echo "error: GB must be a number" >&2; return 3; fi
  if (( gb < 1 || gb > 100 )); then echo "error: GB must be 1-100" >&2; return 4; fi
  echo "quota set: $name ${gb}GB"
}
set_quota "${1:-}" "${2:-}"
exit $?
```

## Try it by hand
```bash
./solution.sh harbour-bakery 40; echo "status $?"
./solution.sh harbour-bakery twenty; echo "status $?"
```

## Alternative
One big `if good && good && good; then ... else ... fi` works, but the failure
messages become hard to attach to the right condition, and the code drifts to the
right as checks accumulate.

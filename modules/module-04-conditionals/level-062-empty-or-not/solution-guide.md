# Walkthrough: Empty or Not

## The plan

The script has one hard requirement (the name) and one optional extra (the
note). Two string questions cover both: "is it empty?" and "is there something
in it?".

## Building it

First, read the arguments in a way that survives them being absent. With
`set -u`, plain `$2` would abort the script when no second argument exists.
`${2:-}` means "the argument, or an empty string if it is not there":

```bash
name="${1:-}"
note="${2:-}"
```

The name is mandatory, so check it first and refuse. `-z` is true for an empty
string. An argument given as `""` and no argument at all both give an empty
`name`, so one test handles both:

```bash
if [[ -z $name ]]; then
  echo "error: customer name required" >&2
  exit 2
fi
```

Exit status 2 is the traditional "you used me wrong" code. Now the happy path.
The ticket line always prints; the note line only when `-n` says there is text:

```bash
echo "ticket for: $name"
if [[ -n $note ]]; then
  echo "note: $note"
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

name="${1:-}"
note="${2:-}"

if [[ -z $name ]]; then
  echo "error: customer name required" >&2
  exit 2
fi

echo "ticket for: $name"

if [[ -n $note ]]; then
  echo "note: $note"
fi
```

## Try it by hand

```bash
./solution.sh "Gull & Anchor Pub" "wifi down"
./solution.sh "Gull & Anchor Pub"
./solution.sh ""; echo "exit=$?"
```

## An alternative

You could test the argument count with `$#` instead of emptiness. That cannot
tell "no name" from "name given as an empty string", and the empty string is
exactly what a form with a blank field sends. Testing the value is more robust.

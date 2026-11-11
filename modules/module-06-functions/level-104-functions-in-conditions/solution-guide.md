# Walkthrough: Functions in Conditions

## The plan
The triage has three outcomes. "Missing" is a plain test; "empty" is the reusable
question, so it becomes a function that the `if` asks directly.

## Building it
The function is a single test. A function's status is the status of its last
command, so the `[[ ... ]]` result becomes the return value with no extra code:

```bash
is_empty_file() {
  [[ -f $1 && ! -s $1 ]]
}
```

`-f` means "is a regular file" and `-s` means "exists and has size above zero",
so `! -s` is "size is zero".

In the loop, put the function where a test would go:

```bash
for f in "$@"; do
  if [[ ! -e $f ]]; then
    echo "$f: missing"
  elif is_empty_file "$f"; then
    echo "$f: empty"
  else
    echo "$f: ok"
  fi
done
```

Why "missing" first? A missing path is not a regular file, so `is_empty_file`
would say no, and we would label it "ok". Order of the branches matters.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
is_empty_file() {
  [[ -f $1 && ! -s $1 ]]
}
for f in "$@"; do
  if [[ ! -e $f ]]; then echo "$f: missing"
  elif is_empty_file "$f"; then echo "$f: empty"
  else echo "$f: ok"
  fi
done
```

## Try it by hand
```bash
touch empty.txt; echo hi > full.txt
./solution.sh empty.txt full.txt nothing.txt
```

## Alternative
Write `[[ -e $f && ! -s $f ]]` inline. It is shorter, but the named function can
be reused and tells the reader what the test means.

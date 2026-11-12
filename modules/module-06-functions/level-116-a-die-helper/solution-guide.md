# Walkthrough: A die() Helper

## The plan
One function for all fatal errors: message to stderr, exit with a code. Then a
list of checks that each read like a sentence: "this must be true, or die".

## Building it
`die` takes the code first and the message after it. `shift` removes the code so
that `$*` is just the message:

```bash
die() {
  local code=$1
  shift
  echo "error: $*" >&2
  exit "$code"
}
```

`exit` (not `return`) is deliberate: the function should end the script, not just
itself. Now the checks use `||`, which runs the right side only when the left
side fails:

```bash
[[ $# -ge 1 ]] || die 2 "usage: solution.sh FILE"
file=$1
[[ -e $file ]] || die 3 "no such file: $file"
[[ -s $file ]] || die 4 "file is empty: $file"
```

`-e` tests existence and `-s` tests "exists and is not empty". The order makes
sure the empty-file check never sees a missing file.

At the end, count lines. `awk 'END { print NR }'` counts a last line even when it
lacks a newline, which `wc -l` would miss and which macOS pads with spaces.

```bash
lines=$(awk 'END { print NR }' "$file")
echo "$file: $lines lines"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
die() {
  local code=$1
  shift
  echo "error: $*" >&2
  exit "$code"
}
[[ $# -ge 1 ]] || die 2 "usage: solution.sh FILE"
file=$1
[[ -e $file ]] || die 3 "no such file: $file"
[[ -s $file ]] || die 4 "file is empty: $file"
lines=$(awk 'END { print NR }' "$file")
echo "$file: $lines lines"
```

## Try it by hand
```bash
./solution.sh; echo "status $?"
./solution.sh nothing.txt; echo "status $?"
```

## Alternative
Repeat `echo ... >&2; exit 3` at each check. It works, but the format of messages
drifts, and changing it (say, adding a timestamp) means editing every place.

# Walkthrough: Empty File?

## The plan

The checkpoint has two outcomes. A file that is missing and a file that is empty
both mean "do not send the report", so we can use one test for both, and then
carry on with the success path knowing the file has content.

## Building it

`-s` is true when the file exists *and* has a size greater than zero (think
"has Size"). We want to fail in the opposite case, so negate it:

```bash
file="$1"
if [[ ! -s $file ]]; then
  echo "empty or missing: $file" >&2
  exit 1
fi
```

That is a guard clause: the problem is dealt with and reported on stderr; the
exit status tells the pipeline to stop. Below it, the file is known to have
content, and we can safely count lines:

```bash
lines=$(( $(wc -l < "$file") ))
echo "ok: $file, lines: $lines"
```

Two small details. `wc -l < "$file"` reads the file from standard input, so
`wc` prints just the number, not the name. On macOS the number comes padded
with spaces; wrapping it in `$(( ))` turns it into a plain integer.

Note that `-s` looks at the size in bytes, not at the text: a file that
contains only one blank line has one byte and counts as non-empty.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

file="$1"

if [[ ! -s $file ]]; then
  echo "empty or missing: $file" >&2
  exit 1
fi

lines=$(( $(wc -l < "$file") ))
echo "ok: $file, lines: $lines"
```

## Try it by hand

```bash
: > empty.csv
printf 'a,b\n1,2\n' > full.csv
./solution.sh empty.csv; echo "exit=$?"
./solution.sh full.csv
```

## An alternative

Combining `[[ -e $file ]]` and `wc -c` works too, but needs more lines and two
steps where `-s` needs one.

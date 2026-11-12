# Walkthrough: Count Lines and Words

## The plan

Loop over the arguments, count each file, print a per-file line, and keep
two running totals for the closing line.

## Step by step

The one trap is how `wc` prints. Try both forms:

```bash
wc -l notes.txt      # "       3 notes.txt"  (padding, plus the name)
wc -l < notes.txt    # "       3"            (macOS pads; GNU wc does not)
```

With the file on standard input, `wc` has no name to print. But BSD `wc`
(macOS) still left-pads the number with spaces. Wrapping it in arithmetic
fixes that, because `$(( ))` evaluates its content as a number and prints it
back without padding:

```bash
lines=$(( $(wc -l < "$f") ))
words=$(( $(wc -w < "$f") ))
```

Now the totals are ordinary integer variables:

```bash
total_lines=$(( total_lines + lines ))
```

For things that are not files (missing paths, folders) we use `[[ -f ]]` and
skip them with a message on stderr, so stdout stays clean for the report.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi
total_lines=0
total_words=0
for f in "$@"; do
  if [[ ! -f $f ]]; then
    echo "skipping $f (not a file)" >&2
    continue
  fi
  lines=$(( $(wc -l < "$f") ))
  words=$(( $(wc -w < "$f") ))
  echo "$f: $lines lines, $words words"
  total_lines=$(( total_lines + lines ))
  total_words=$(( total_words + words ))
done
echo "total: $total_lines lines, $total_words words"
```

## Try it by hand

```bash
printf 'one two\nthree\n' > a.txt
./solution.sh a.txt missing.txt
```

## An alternative

`wc -l < "$f" | tr -d ' '` also removes the padding, but then the value is
still a string. With `$(( ))` the result is a real number you can add
immediately, and the padding disappears as a side effect.

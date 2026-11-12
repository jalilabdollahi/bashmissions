# Walkthrough: Sort Lines

## The plan
We need the lines of standard input in order. Writing a loop that compares
strings would be silly: `sort` is a filter that reads lines and writes them
back in order.

## Step by step
1. Nothing has to be read by hand. A filter with no file arguments reads
   standard input, so the script can be a single command.

2. Understand the order. `sort` compares two lines character by character. In
   the plain `C` locale (which the game sets with `LC_ALL=C`) that means byte
   order: digits, then capital letters, then lowercase letters. So:

   - `rack10-dory` vs `rack2-eel`: the first differing characters are `1` and
     `2`, and `1` is smaller, so rack 10 comes first.
   - `Eel` vs `anchovy`: `E` is smaller than `a`, so capitals come first.

   That is why the label printer showed rack 10 before rack 2: nothing broke,
   `sort` just compares text, not numbers.

3. Duplicates stay. Plain `sort` never removes lines; only `sort -u` does.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sort
```

## Try it by hand
```bash
printf 'rack9\nrack10\nrack2\n' | sort        # rack10, rack2, rack9
printf 'b\nA\na\nB\n' | sort                  # A, B, a, b  (C locale)
printf 'b\nA\na\nB\n' | LC_ALL=en_US.UTF-8 sort   # a, A, b, B on many systems
sort -r names.txt                              # reversed
```

## Alternative
`sort -f` ignores case and `sort -u` drops duplicates. Both are useful in other
jobs, but they change the answer here. Setting `LC_ALL=C` inside the script is
also common when you need the same order on every machine, because locales
change how letters compare.

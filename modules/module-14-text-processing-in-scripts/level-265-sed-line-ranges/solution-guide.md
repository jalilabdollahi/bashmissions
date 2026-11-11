# Walkthrough: sed Line Ranges

## The plan
We want whole blocks of a file, delimited by marker lines. sed supports exactly
that: an address can be a pair, "from a line matching this to a line
matching that", and every command attached to it runs for all lines in
between.

## Step by step
1. Without options, sed prints every line it reads. For a selection we want the
   opposite: silence by default, and print only chosen lines. That is `-n`.

2. Write the range as `/first/,/last/`. When a line matches `/first/`, the
   range opens and that line is selected. The range stays open and selects every
   following line until one matches `/last/`; that line is selected too, and
   the range closes. After that, sed starts looking for `/first/` again, so a
   second block works with no extra effort.

3. Add `p` to print the selected lines:

   ```bash
   sed -n '/BEGIN backup/,/END backup/p' "$1"
   ```

4. Check the edge cases. A block with no END simply never closes, so
   everything to the end of the file is printed. A file with no BEGIN
   selects nothing, and sed exits with status 0 and no output.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sed -n '/BEGIN backup/,/END backup/p' "$1"
```

## Try it by hand
```bash
seq 1 10 | sed -n '3,5p'                 # 3 4 5
seq 1 10 | sed -n '/4/,/6/p'             # 4 5 6
seq 1 10 | sed '/4/,/6/d'                # everything except 4 to 6
seq 1 10 | sed -n '/8/,$p'               # from the first 8 to the end of file
```

## Alternative
awk has the same idea with a flag variable: `awk '/BEGIN backup/ {on=1} on {print} /END backup/ {on=0}'`.
It is more flexible (you can exclude the markers, count blocks, and so on),
but for "print this block" the sed range is the idiom everybody reads at a
glance.

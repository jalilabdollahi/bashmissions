# Walkthrough: Set Differences

## The plan
"Who joined" is the set of lines in NEW minus OLD; "who left" is OLD minus NEW.
`comm` ("common") compares two sorted files line by line and produces exactly
the three groups we need.

## Step by step
1. Understand comm's three columns. For two sorted inputs it prints:
   - column 1: lines only in the first file
   - column 2: lines only in the second file
   - column 3: lines in both
   Each option `-1`, `-2` or `-3` suppresses one column. If only a single column
   is left, the lines come out plain, with no leading tab.

2. Sorted input is not optional. comm walks both files together; with unsorted
   input it prints warnings and wrong results. Sort both with process
   substitution, which needs no temporary files:

   ```bash
   <(sort "$old") <(sort "$new")
   ```

3. Joiners are lines only in the second file: hide columns 1 and 3, so `-13`.
   Leavers are only in the first: hide 2 and 3, so `-23`.

4. Add the prefix with sed: `s/^/+ /` replaces the empty string at the start of
   each line by `+ `. Run the two groups in order, joiners first.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
old=$1 new=$2
comm -13 <(sort "$old") <(sort "$new") | sed 's/^/+ /'
comm -23 <(sort "$old") <(sort "$new") | sed 's/^/- /'
```

## Try it by hand
```bash
printf 'a\nb\nc\n' > x; printf 'b\nc\nd\n' > y
comm x y             # three columns, tab-indented
comm -12 x y         # b c   (the intersection)
comm -23 x y         # a
comm -13 x y         # d
```

## Alternative
`grep -Fxvf old new` prints lines of new that are not in old (whole-line,
fixed-string match) and needs no sorting. It is fine for small lists, but it
reads one file entirely into memory, gives `1` as exit status for no
output, and does not give the three-way view that `comm` gives you for free.

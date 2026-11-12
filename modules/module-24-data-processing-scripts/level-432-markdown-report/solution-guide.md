# Walkthrough: Markdown Report

## The plan
Read and judge every row first, remembering what the report needs: how many
valid items there are, and the finished table row of every low one. Print the
document in `END`, when all the numbers are known, choosing between a table and
a note.

## Step by step
1. **Validate.** Skip the header and blank lines, strip `\r`. If stock or
   reorder level is not digits, report `skipped line N` and ignore the row.
   Without this check, `many` would compare as 0 and wrongly count as low.

2. **Count and collect.** `total++` for every valid row. If
   `$3 + 0 <= $4 + 0` (numbers, so 9 is less than 10), store the SKU in
   `sku[n]` and the complete Markdown row in `line[n]`.

3. **Escape the delimiter.** In Markdown tables `|` ends a cell. `mdesc()` copies
   the name piece by piece, putting `\|` where a bar was. Using `index()`
   avoids the awk-specific rules for backslashes in `gsub` replacements.

4. **Sort.** The rows are in file order; the report wants SKU order. A short
   insertion sort moves `sku[]` and `line[]` together. The `"" > ""` trick makes
   sure they compare as text.

5. **Print the document.** Title, blank line, then either the three table parts
   (header, separator `|---|---|---:|---:|`, rows) or `_Nothing to reorder._`, a
   blank line, and the summary. Blank lines matter: many Markdown renderers need
   one before and after a table.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
./solution.sh stock.csv
./solution.sh stock.csv 2>&1 >/dev/null     # only the skipped-line warnings
```

## Alternative
A `printf` per row inside a Bash loop works for a tiny report, but sorting,
counting and the conditional "no table" case all want the data collected
first. One awk program that gathers and then prints is simpler than a loop
that tries to print as it goes.

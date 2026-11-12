# Walkthrough: Pivot Table

## The plan
A pivot table is three numbers hiding in a single pass: a total per
(row, column) pair, a total per row, and a total per column. Since the rows and
columns of the output depend on what is in the data, the script also has to
remember the distinct names, put them in order, and print everything in
`END`.

## Step by step
1. **Filter the input.** Strip `\r`, skip blank lines and the header (`NR == 1`).
   A signups value that is not digits is reported with its line number and
   skipped.

2. **Accumulate.** `cell[$1, $2] += $3` uses two subscripts; awk glues them
   with the hidden separator `SUBSEP` into one key. Row, column and grand totals
   are updated on the same line, so the totals can never disagree with the
   cells.

3. **Remember the names in order of appearance.** The first time a region
   shows up, `rows[++nr] = $1` stores it in the next slot. `seen` arrays make
   sure each name is stored once. Same for plans.

4. **Sort them.** `isort` is a classic insertion sort. The `a[j] "" > t ""`
   trick concatenates an empty string to both sides, turning them into plain
   text before the comparison. Without it, region `10` would sort before `9`
   (numbers) in one awk and after it in another.

5. **Print.** Header first (`region`, each plan, `total`), then every region:
   for each plan the cell value, with `+ 0` to turn "never seen" into 0, then
   the row total. Last comes the `total` row with column totals and the grand
   total. With no rows, both lists are empty and the output collapses to
   `region,total` and `total,0`, as required.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
printf 'a,x,1\na,y,2\nb,x,3\n' | awk -F, '{ c[$1, $2] += $3 } END { print c["b", "y"] + 0, c["a", "y"] }'
./solution.sh signups.csv
```

## Alternative
`sort | uniq` can group by two fields, but it cannot add a column, and it has no
notion of a missing cell, so the zeros and the totals have to be built by hand.
For heavier pivots people reach for a spreadsheet or SQL; this is the same
idea, in about thirty lines.

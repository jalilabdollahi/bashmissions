# Walkthrough: Latest Record Wins

## The plan
Stream through the log once, remembering for each customer only the newest row
seen so far. At the end print one row per customer in email order.

## Step by step
1. **Header.** `{ read ...; awk ...; } < "$1"` opens the file once for the
   whole group. `read` consumes line 1, so the awk that follows starts at line
   2. The header is printed as is (minus a `\r`), outside of the sort that
   would otherwise move it into the data. An empty file makes `read` fail with
   nothing in `header`, and the script exits quietly. A header without a final
   newline also makes `read` fail but fills `header`, which is why the test is
   `! read && -z $header`.

2. **Validate.** Rows with an empty email or a timestamp that is not exactly
   `YYYY-MM-DDTHH:MM:SSZ` are reported. awk's `NR` counts from the line after
   the header, so `NR + offset` (offset 1) is the true file line number.

3. **Pick the winner.** `key = tolower($1)` folds case, so `Theo@X` and
   `theo@x` are one customer. If the key is new, or `$2 >= stamp[key]`, store
   the timestamp and the row. Timestamps are compared as text, which is correct
   for fixed-width ISO timestamps in one time zone. `>=` means the later line
   wins when two rows share a timestamp.

4. **Rebuild the row.** The email must print in lowercase, so the stored row is
   `key "," substr($0, length($1) + 2)`: the new key followed by everything after
   the original first comma. Extra columns survive.

5. **Order.** `for (k in row)` has no useful order. `sort -t, -k1,1` sorts by
   the email alone; sorting the whole line would put `a-b@` and `a@` in a
   different order, because the comma (the field separator) sorts before the
   hyphen.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
./solution.sh subs.csv
{ read -r first; echo "header: $first"; wc -l; } < subs.csv   # wc sees the rest
```

## Alternative
`sort -t, -k1,1 -k2,2r | awk` (sort by email, then newest first, keep the first
of each email) also works and needs no array. It sorts the whole file first,
though, and the tie rule and lowercasing need extra care. The array approach
keeps only one row per customer in memory.

# Walkthrough: Join Two CSVs

## The plan
Load the customers into an associative array keyed by id, then read the
invoices once, replacing each id with the name found in the array. The invoices
keep their order because they are never sorted or rearranged.

## Step by step
1. **Order of files.** awk processes its file arguments left to right. The
   script is called with invoices first, customers second, so the awk command
   lists `"$2" "$1"`: lookup file first.

2. **Which file am I in?** `NR` is the running line number over everything;
   `FNR` is the line number within the current file. They are equal only in the
   first file, so `FNR == NR { ...; next }` is the "customers" rule, and the
   rules below it only ever see invoice lines because of `next`.

3. **Load the table.** Skip the customers header (`FNR > 1`) and store
   `name[$1] = $2`. The `!($1 in name)` test makes the first occurrence win on
   duplicate ids.

4. **Header of the output.** For the invoices file, `FNR == 1` prints the new
   header `invoice,name,amount` instead of the old one.

5. **Look up.** `who = ($2 in name) ? name[$2] : "UNKNOWN"`, then
   `print $1, who, $3` with `OFS=,`.

6. **Clean-up.** `sub(/\r$/, "")` and `$0 == "" { next }` come first and apply
   to both files.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, -v OFS=, '
  { sub(/\r$/, "") }
  $0 == "" { next }
  FNR == NR { if (FNR > 1 && !($1 in name)) name[$1] = $2; next }
  FNR == 1  { print "invoice,name,amount"; next }
  { who = ($2 in name) ? name[$2] : "UNKNOWN"; print $1, who, $3 }
' "$2" "$1"
```

## Try it by hand
```bash
./solution.sh invoices.csv customers.csv
awk 'FNR == NR { n++; next } END { print n }' customers.csv /dev/null
```

## Alternative
`join -t, -1 2 -2 1` joins on a key, but both files must be sorted on it, the
header gets in the way, unmatched invoices are dropped unless you add `-a 1`,
and the output order is the key order, not the invoice order. When the order
and the unmatched rows matter, the array lookup is simpler and more honest.

# Walkthrough: awk Group By

## The plan
"Per customer" means we need a separate total for each distinct value in a
column, and we do not know the values ahead of time. awk's associative arrays
are built for this: an array whose index is any text.

## Step by step
1. Skip the header and set the separator. `-F,` splits at commas, and the
   pattern `NR > 1` makes the action run for every line except the first.

2. Count rows per customer. `rows[$2]++` takes the customer name in field 2 as
   the index. The first time a name is seen its element springs into existence
   as 0, then goes up by one.

3. Add up bandwidth per customer in the same action: `gb[$2] += $3`.

4. Report in `END`. `for (c in rows)` visits every key once. Print the key
   and both values, joined with commas by plain string concatenation:

   ```awk
   END { for (c in rows) print c "," rows[c] "," gb[c] }
   ```

5. Fix the order. awk gives no guarantee about the order of keys; mawk on
   Debian and BSD awk on macOS differ. Piping the output through `sort`
   makes the report identical everywhere.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, '
  NR > 1 { rows[$2]++; gb[$2] += $3 }
  END    { for (c in rows) print c "," rows[c] "," gb[c] }
' "$1" | sort
```

## Try it by hand
```bash
printf 'x,a,1\nx,b,2\nx,a,3\n' | awk -F, '{ s[$2] += $3 } END { for (k in s) print k, s[k] }'
./solution.sh traffic.csv
if ("a" in s) ...      # test for a key without creating it (inside an awk program)
```

## Alternative
`cut | sort | uniq -c` counts rows per customer, but it cannot add a second
column. As soon as you need sums, averages or "latest value per key", awk
arrays are the tool, and they need only one pass over the file.

# Walkthrough: Cut Columns

## The plan
The export is a table written as text: one row per line, columns separated by
commas. We do not need to understand the data, only to keep columns 2 and 5 of
every row. That is what `cut` does.

## Step by step
1. Find the column numbers. Reading the header `invoice,customer,plan,seats,amount,status`
   from the left and counting from 1, the customer is field 2 and the amount is
   field 5.

2. Tell `cut` how the line is split. By default it splits at tab characters, so
   a CSV needs the delimiter option:

   ```bash
   cut -d, ...
   ```

3. Tell it which fields to keep with `-f`. A comma-separated list keeps several
   fields; `cut` prints them in their original order, joined with the delimiter:

   ```bash
   cut -d, -f2,5 "$1"
   ```

4. There is no special handling for the header. It is just the first line, and
   `cut` trims it like any other. That is the beauty of line-based tools: they
   do not care what a line means.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
cut -d, -f2,5 "$1"
```

## Try it by hand
```bash
printf 'a,b,c,d,e,f\n1,2,3,4,5,6\n' > t.csv
./solution.sh t.csv       # prints b,e then 2,5
cut -d, -f2- t.csv        # everything from field 2 to the end
cut -d, -f1-3 t.csv       # fields 1 to 3
```

## Alternative
`awk -F, '{print $2 "," $5}'` gives the same result and can do far more, but it
is heavier than the job needs. For "keep these columns" `cut` is shorter and
faster, and everyone who reads it knows at once what it does. awk comes later in
this module, when you need arithmetic or conditions.

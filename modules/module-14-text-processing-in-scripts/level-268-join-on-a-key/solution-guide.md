# Walkthrough: Join on a Key

## The plan
We have two tables linked by a code. `join` connects them, like a relational
database. It relies on a trick that makes it fast: if both inputs are sorted by
the key, it can walk down the two files together like a zip, never searching.
That trick is also its limitation, so we have to give it sorted input.

## Step by step
1. Know the output format. For each key found in both files, `join` prints the
   key, then the remaining fields of the first file, then the remaining fields
   of the second: `C01,Harbour Bakery,120.00`. That is exactly the wanted
   format.

2. Set the separator on the join: `-t,`. Without it, join splits at blanks and
   a name like `Gull & Anchor Pub` would break into pieces.

3. Sort both inputs on the key, field 1 only: `sort -t, -k1,1 file`. Sorting the
   whole line is different, because a comma sorts before many characters, so
   `C1,x` and `C10,y` can end up in an order that disagrees with the keys `C1`
   and `C10`, and join will lose matches.

4. Feed the sorted streams without temporary files using process substitution:

   ```bash
   join -t, <(sort -t, -k1,1 "$1") <(sort -t, -k1,1 "$2")
   ```

   `<(...)` runs the command and gives `join` a `/dev/fd/N` path to read.

5. The output is in key order, and keys missing from either file are dropped.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
join -t, <(sort -t, -k1,1 "$1") <(sort -t, -k1,1 "$2")
```

## Try it by hand
```bash
printf 'b,2\na,1\n' > L; printf 'a,x\nc,z\n' > R
join -t, <(sort L) <(sort R)         # a,1,x
join -t, L R                         # warns about unsorted input on GNU
join -t, -a 1 <(sort L) <(sort R)    # also keep unmatched lines of the first file
```

## Alternative
`awk` can do the same with an array: load the customers into `name[$1]` and
look up each invoice. It does not need sorted input, and for a join with
unusual rules it is more flexible. For a plain key match, `join` states the
intent directly and works on files too large to hold in memory.

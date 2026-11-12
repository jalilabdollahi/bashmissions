# Walkthrough: Side by Side

## The plan
Three files, one value per line, line N describes machine N. The job is to
glue line N of each file into one row. That is not a loop or a join on a key;
it is just "zip the files together", and `paste` does it.

## Step by step
1. `cat a b c` would put all names, then all addresses, then all owners one
   below the other. `paste a b c` instead takes line 1 from each file, joins
   them, then line 2 from each, and so on.

2. The default delimiter is a tab character. The output wants commas, so
   `-d,` (delimiter comma):

   ```bash
   paste -d, "$1" "$2" "$3"
   ```

3. Short files cause no problem. When `ips.txt` has two lines and the others
   three, `paste` prints `flounder,,ollie` for the last row: the missing value
   becomes an empty field and the delimiters stay, so a later `cut` or `awk`
   still sees three columns.

4. Values with spaces are fine too, because the only separator paste adds is the
   one you choose.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
paste -d, "$1" "$2" "$3"
```

## Try it by hand
```bash
printf 'a\nb\n' > x; printf '1\n2\n' > y
paste x y                 # a<TAB>1
paste -d, x y             # a,1
paste -sd, x              # a,b   (serial: one line)
paste -d, x - < y         # "-" reads standard input as a column
```

## Alternative
A `while read` loop over three file descriptors can do the same, but it
needs `exec 3<` and friends and mishandles unequal lengths. `paste` is a
single command, and it is the right tool whenever the relation between the
files is "same line number".

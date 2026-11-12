# Walkthrough: Frequency Table

## The plan
"How many times does each page appear?" is a question about a column of text.
It splits into four tiny jobs, and each one has its own classic tool.

## Step by step
1. Extract the column. The path is the third space-separated field:

   ```bash
   cut -d' ' -f3 "$1"
   ```

2. Group equal lines. `uniq` only merges neighbours, so sort first. After
   `sort`, all the `/menu` lines are in one block.

3. Count each block. `uniq -c` prints the count and then the line:

   ```
      3 /menu
   ```

   The count is right-aligned in a padded column, and the padding width differs
   between macOS and Linux. Strip it so the output is identical everywhere:
   `sed 's/^ *//'`.

4. Order by count. A second `sort` on the count field, numerically and
   reversed: `-k1,1nr`. Add `-k2,2` so equal counts fall back to the path.
   Without the `n`, a count of 11 would sort after 9.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
cut -d' ' -f3 "$1" | sort | uniq -c | sed 's/^ *//' | sort -k1,1nr -k2,2
```

## Try it by hand
```bash
printf 'a\nb\na\nc\na\nb\n' | sort | uniq -c
printf 'a\nb\na\nc\na\nb\n' | sort | uniq -c | sort -rn
./solution.sh access.log | head -n 3     # the podium
```

## Alternative
`awk '{c[$3]++} END {for (p in c) print c[p], p}'` counts without sorting
first, and you will write that in an upcoming level. For a quick tally on
the command line, the four-stage pipeline is so common that people type it from
memory.

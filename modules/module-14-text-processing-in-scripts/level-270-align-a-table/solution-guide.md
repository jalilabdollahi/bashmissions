# Walkthrough: Align a Table

## The plan
A table that lines up needs every column to be a fixed width, whatever the
data is. `printf` does that with width numbers in its format, and awk has its
own `printf`, so we can read the CSV and format it in one program.

## Step by step
1. Read the format. `%s` prints a string; a number between the `%` and the
   `s` is the minimum width. Without a sign the text is right-aligned in that
   width, with a minus (`%-12s`) it is left-aligned. Our format is
   `"%-12s %-10s %5s\n"`: two left-aligned text columns and one right-aligned
   number column, separated by single spaces.

2. Remember the newline. Unlike `print`, `printf` writes exactly what the
   format says, so the `\n` at the end is yours to add.

3. Print the header once. A `BEGIN` block runs before awk reads any input,
   which is the right place for a title line, and it runs even for an empty
   file. Keeping the format in a variable guarantees that the header and the
   rows share the same widths.

4. For each CSV row, call `printf` with the same format and fields 1, 2, 3
   (`-F,` splits at commas).

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, '
  BEGIN { fmt = "%-12s %-10s %5s\n"; printf fmt, "HOST", "ROLE", "CPU%" }
  { printf fmt, $1, $2, $3 }
' "$1"
```

## Try it by hand
```bash
printf '|%-6s|%6s|\n' ab cd
printf '%-5s %3d%%\n' dory 7        # %d is an integer, %% a literal percent sign
awk 'BEGIN { printf "%.1f\n", 2.345 }'
```

## Alternative
The `column -t` command aligns a table automatically, but it is not available
on every system and it sizes columns from the data, so two runs of the same
report may have different widths. Explicit widths with `printf` are a
little more typing and fully predictable.

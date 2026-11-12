# Walkthrough: Parse CSV Rows

## The plan
A loop reads the file one line at a time. For each line, `read` splits the line
at commas into named variables, and an `if` keeps only the open invoices. A
counter feeds the summary line at the end.

## Step by step
1. **Split on commas.** `IFS=, read -r invoice customer amount status` puts the
   four columns into four variables. `IFS=,` is written in front of `read`, so
   it applies to that command only and the rest of the script keeps its normal
   separators. `-r` stops `read` from eating backslashes.

2. **Skip the header.** A plain `read -r _header` before the loop consumes line
   1. It has to read from the same open file as the loop, so both live inside
   one `{ ...; } < "$1"` group. If they used separate redirections, each would
   start at the top of the file again.

3. **Keep the last line.** If the file does not end with a newline, `read`
   returns failure on the final line, yet the variables are filled. Adding
   `|| [[ -n $invoice ]]` runs the body once more when data was read anyway.

4. **Windows files.** A `\r\n` ending leaves a `\r` glued to the last column, so
   `open` would never equal `open\r`. Strip it: `status=${status%$'\r'}`.

5. **Blank lines.** All variables are empty (or, in a Windows file, `invoice` is just `\r`, so strip that too); then `[[ -z $invoice ]] && continue`.

6. **Print and count.** Compare with `==` inside `[[ ]]`; print with `printf`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
count=0
{
  read -r _header || true
  while IFS=, read -r invoice customer amount status || [[ -n $invoice ]]; do
    invoice=${invoice%$'\r'}
    status=${status%$'\r'}
    [[ -z $invoice ]] && continue
    if [[ $status == open ]]; then
      printf '%s | %s | %s\n' "$invoice" "$customer" "$amount"
      count=$((count + 1))
    fi
  done
} < "$1"
printf 'open invoices: %d\n' "$count"
```

## Try it by hand
```bash
printf 'a,b,c\n' | { IFS=, read -r x y z; echo "$y"; }
./solution.sh invoices.csv
```

## Alternative
`awk -F, '$4 == "open"'` does the filtering in one line, and the next levels use
it a lot. The `read` loop is the right tool when each row needs real Bash logic
(calling commands, branching, building strings), and it is the only one that
needs no extra process.

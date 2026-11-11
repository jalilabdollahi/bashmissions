# Walkthrough: Line by Line

## The plan
Validate the argument, then feed the file into a `while read` loop that prints each line inside bars. The loop must not alter any line on its way through.

## Step by step
1. Argument check: if `$#` is not exactly 1, print the usage line on stderr and `exit 2`.
2. File check: `[[ ! -r $file ]]` is true when the file is missing or unreadable. Print `cannot read ...` on stderr and `exit 1`. Doing this up front gives a friendly message instead of Bash's own error.
3. The loop: `while IFS= read -r line; do`. `read` takes one line from standard input and stores it in `line`; it returns failure at end of input, which ends the loop.
   - `IFS=` (an empty value just for this command) stops `read` from stripping leading and trailing spaces.
   - `-r` stops `read` from treating backslash as an escape character.
4. Print `|$line|` in the body.
5. Attach the file to the loop's input with `done < "$file"`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi
while IFS= read -r line; do
  echo "|$line|"
done < "$file"
```

## Trying it by hand
Create a file with `printf '  two spaces\nC:\\temp\n' > t.txt` and run the script. Then remove `IFS=` and `-r` one at a time and compare the results; the bars make the difference obvious.

## An alternative
`for line in $(cat file)` splits on every space, not on lines, and expands wildcards inside the text. It is the wrong tool for line-oriented data. `mapfile -t lines < file` loads everything into an array, which is fine for small files; the `while read` loop works one line at a time and handles huge files.

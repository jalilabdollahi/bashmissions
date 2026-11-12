# Walkthrough: Stop at the First Match

## The plan
A search loop has three moves: test the current item, remember it if it matches, and leave the loop. Afterwards the script checks what it remembered.

## Step by step
1. Start with the usage check: no arguments, usage on stderr, `exit 2`.
2. Create the memory: `hit=""`. An empty string means "nothing found yet".
3. Loop over the files with `for file in "$@"; do`.
4. Test each file with `grep -q`. The option `-q` makes `grep` silent and lets its exit status speak: 0 for "found". The pattern `'^PermitRootLogin[[:space:]]+yes'` is anchored at the start of the line, so `#PermitRootLogin yes` (a comment) does not match, and `[[:space:]]+` allows one or more blanks between the words. For a file that does not exist, `grep` fails, so the file is skipped; `2>/dev/null` hides its complaint.
5. When it matches: `hit=$file` and `break`. The remaining files are never opened.
6. After the loop, `[[ -n $hit ]]` tells whether the search succeeded. Print the result, or the "no insecure config found" message with `exit 1`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi
hit=""
for file in "$@"; do
  if grep -q -E '^PermitRootLogin[[:space:]]+yes' "$file" 2>/dev/null; then
    hit=$file
    break
  fi
done
if [[ -n $hit ]]; then
  echo "first insecure config: $hit"
else
  echo "no insecure config found"
  exit 1
fi
```

## Trying it by hand
`printf 'PermitRootLogin yes\n' > bad.conf` and `printf 'PermitRootLogin no\n' > ok.conf`, then `bash solution.sh ok.conf bad.conf` and `echo $?`.

## An alternative
`grep -l -E '...' "$@" | head -n 1` also prints the first matching file, with no loop. It is shorter, and the loop is better once each file needs more than a single test, or when you want to take a different action for the first hit.

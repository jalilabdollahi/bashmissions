# Walkthrough: Contains a Substring

## The plan
Read the log line by line. Number every line (matching or not). When a line
contains the search word, print it with its number and bump a counter. After the
loop print the total.

## The "contains" test
`[[ $line == *"$word"* ]]`: the pattern is "anything, the word, anything". The
stars at the two ends are unquoted, so they are wildcards. The word is quoted, so
whatever it holds is compared as plain characters. That detail is what makes
`[WARN]` and `a*b` behave:

| unquoted `*$word*` | quoted `*"$word"*` |
|---|---|
| `[WARN]` means "one of the letters W, A, R, N" | the text `[WARN]` |
| `a*b` matches `axxb` | only the text `a*b` |

## Counting
Two counters start at zero. `lineno` goes up on every line, `matches` only on a
hit. `$(( ... ))` does the arithmetic (you will study it fully in the next
module).

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
word=$1
lineno=0
matches=0
while IFS= read -r line || [[ -n $line ]]; do
  lineno=$((lineno + 1))
  if [[ $line == *"$word"* ]]; then
    echo "line $lineno: $line"
    matches=$((matches + 1))
  fi
done
echo "matches=$matches"
```

## Try it by hand
```bash
printf 'ok\ntimeout on db\nok\n' | ./solution.sh timeout
printf '[WARN] a\nW b\n' | ./solution.sh "[WARN]"
```

## Alternative
`grep -nF -- "$word"` prints similar output (and `-F` means "fixed string"). It
is the right tool for big files, because Bash loops over lines slowly. For short
inputs, or on systems without grep, the built-in test keeps the script
self-contained.

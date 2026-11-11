# Walkthrough: Replace eval

## The plan
The old script made a *string* that looked like a command and asked the shell to
run it. We build a real list of arguments instead, and the only text that ever
enters it is text we typed ourselves.

## Why eval is the problem
`eval "grep $pattern logs/app.log"` first expands `$pattern`, then parses the
result as shell code. If the pattern is `$(touch pwned)` the substitution runs
before grep even starts. Quoting the variable inside the string does not help,
because eval parses the string a second time.

## Steps
1. Keep the first argument as the pattern and `shift` it away, so `"$@"` is
   only the option words.
2. Start an empty array: `flags=()`.
3. Loop over the option words. A `case` is an allow-list: only the three words
   we wrote match, each appends a literal flag we chose.
   ```bash
   case $word in
     ignore-case) flags+=(-i) ;;
     count)       flags+=(-c) ;;
     invert)      flags+=(-v) ;;
     *) printf 'unknown option: %s\n' "$word" >&2; exit 2 ;;
   esac
   ```
4. Run the command with the array and the pattern as separate arguments:
   `grep "${flags[@]}" -F -e "$pattern" logs/app.log`.
   The pattern is only ever *an argument*, never part of a command line that is
   parsed again. `-F` turns off regex meaning and `-e` stops a leading `-v` from
   being read as a flag.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh PATTERN [OPTION...]" >&2
  exit 2
fi
pattern=$1
shift
flags=()
for word in "$@"; do
  case $word in
    ignore-case) flags+=(-i) ;;
    count)       flags+=(-c) ;;
    invert)      flags+=(-v) ;;
    *) printf 'unknown option: %s\n' "$word" >&2; exit 2 ;;
  esac
done
grep "${flags[@]}" -F -e "$pattern" logs/app.log
```

## Try it
```
./solution.sh error ignore-case count
./solution.sh '$(touch pwned)'; ls pwned
```

## Alternative
An associative array (`declare -A map=([count]=-c ...)`) can replace the case,
and `${map[$word]:-}` tells you whether the word is known. `case` is easier to
read for three entries and needs nothing beyond Bash basics.

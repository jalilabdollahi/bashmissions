# Walkthrough: The main() Pattern

## The plan
The behaviour stays; the layout changes. Every line that currently runs at top level
moves into a function called `main`, helpers stay above it, and the file ends with
the one line that starts it all.

## Steps
1. Keep `count_lines` where it is. It only defines something.
2. Open `main() {` and move into it: the usage check, the two counters, the loop and
   the summary.
3. The old script ended with `exit "$missed"`. Inside a function you want `return`
   instead; the status of `main "$@"` becomes the script's status. Likewise the
   usage branch uses `return 2` rather than `exit 2`.
4. Delete the TODO comment and put `main "$@"` alone on the last line. The quotes
   matter: they pass `Harbour Bakery.txt` as one argument.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

count_lines() {
  echo $(( $(wc -l < "$1") ))
}

main() {
  if [ "$#" -eq 0 ]; then
    echo "usage: solution.sh FILE..." >&2
    return 2
  fi
  local total=0 missed=0 f n
  for f in "$@"; do
    if [ -r "$f" ]; then
      n=$(count_lines "$f"); echo "$f: $n lines"; total=$((total + n))
    else
      echo "skip: $f" >&2; missed=1
    fi
  done
  echo "total: $total"
  return "$missed"
}

main "$@"
```
(`local` is covered properly in level 281; here it simply keeps the counters inside `main`.)

## Try it
```
printf 'a\nb\n' > x.txt
./solution.sh x.txt nothere.txt; echo "exit $?"
```

## Alternative
You could leave the code at top level and add a comment header per section. That
works until the first helper needs to be called before it is defined; with `main`,
bash has read every definition before the program starts, so order never bites.

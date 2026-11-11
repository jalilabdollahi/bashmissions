# Walkthrough: Globs Not ls

## The plan
Let the shell expand `"$dir"/*.log` itself, loop over the results one by one,
and print a first-line summary for the real files.

## Why ls loses
`$(ls ...)` turns the file list into one string. Word splitting then cuts it at
spaces, tabs and newlines, so `Harbour Bakery.log` becomes two items, and glob
characters inside names get expanded a second time. `ls` also reformats or
escapes odd characters on some systems. The glob has none of these problems:
each match is delivered as exactly one word, the real name.

## Steps
1. Keep the usage and folder checks.
2. `shopt -s nullglob`: with no match, the loop body runs zero times instead of
   once with the literal text `dir/*.log`.
3. `for f in "$dir"/*.log; do`. The variable is quoted (the folder may have
   spaces), the star is not (we want it expanded).
4. `[[ -f $f ]] || continue` skips folders such as `old.log`.
5. `IFS= read -r first < "$f" || true` reads one line without trimming or
   backslash handling. On an empty file `read` fails, and `|| true` stops
   `set -e` from ending the script.
6. Print `${f##*/}: $first`, which strips the folder from the name, and count.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1
if [[ ! -d $dir ]]; then
  printf 'no such folder: %s\n' "$dir" >&2
  exit 1
fi
shopt -s nullglob
count=0
for f in "$dir"/*.log; do
  [[ -f $f ]] || continue
  first=
  IFS= read -r first < "$f" || true
  printf '%s: %s\n' "${f##*/}" "$first"
  count=$((count + 1))
done
printf 'logs: %d\n' "$count"
```

## Try it
```
mkdir -p t; echo hi > "t/my file.log"; mkdir t/old.log
./solution.sh t
```

## Alternative
`find "$dir" -maxdepth 1 -name '*.log' -type f -print0` with `read -d ''` is the
right tool when you need recursion or filters a glob cannot express. For one
folder, the glob is shorter and has no extra process.

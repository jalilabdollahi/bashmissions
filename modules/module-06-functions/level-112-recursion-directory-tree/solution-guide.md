# Walkthrough: Recursion: Directory Tree

## The plan
One function that handles a single folder, and calls itself for every sub-folder.
An extra argument remembers how deep we are, so each level is indented further.

## Building it
Loop over the entries. The glob `"$dir"/*` sorts alphabetically and skips hidden
names. If the folder is empty the pattern stays as literal text, so guard against
it:

```bash
for entry in "$dir"/*; do
  [[ -e $entry ]] || continue
```

`${entry##*/}` strips everything up to the last `/`, leaving only the file or
folder name. Print files plainly. For a folder, print it with `/` and then recurse:

```bash
if [[ -d $entry ]]; then
  echo "$indent$name/"
  walk "$entry" "$indent  "
else
  echo "$indent$name"
fi
```

The recursion ends by itself: a folder with no sub-folders simply makes no more
calls. That is the base case, hidden in the data.

Unlike the factorial, `walk` prints directly instead of through `$( )`, so there is
no subshell cost and each call just writes lines in order. The `local` line gives
each level its own `dir`, `indent` and `entry`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
walk() {
  local dir=$1 indent=$2 entry name
  for entry in "$dir"/*; do
    [[ -e $entry ]] || continue
    name=${entry##*/}
    if [[ -d $entry ]]; then
      echo "$indent$name/"
      walk "$entry" "$indent  "
    else
      echo "$indent$name"
    fi
  done
}
root=${1:-}
if [[ ! -d $root ]]; then
  echo "no such directory: $root" >&2
  exit 1
fi
root=${root%/}
echo "$root/"
walk "$root" "  "
```

## Try it by hand
```bash
mkdir -p demo/a/b; touch demo/a/b/x.txt demo/top.txt
./solution.sh demo
```

## Alternative
`find demo | sort` lists every path in one line each, no recursion code at all.
It is shorter, but you would need extra text processing to get the indentation.
Writing it by hand is the way to learn how recursion follows nested data.

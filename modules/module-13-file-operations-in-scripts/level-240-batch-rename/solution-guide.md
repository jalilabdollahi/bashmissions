# Walkthrough: Batch Rename

## The plan

For each `FOLDER/*.OLD`: compute the new name, skip if taken, otherwise
`mv`. Keep two counters for the summary.

## Step by step

The loop uses a glob with the extension from an argument. Quote the
variable parts, leave the `*` bare:

```bash
for path in "$folder"/*."$old"; do
```

Spaces in names are safe because the glob expands to whole names, never
re-split. But a glob with no match stays literal (`uploads/*.jpeg`), which
would make the loop run once with a fake file. `shopt -s nullglob` makes it
expand to nothing, and `[[ -f $path ]] || continue` skips folders that
happen to end in the extension.

The new name uses the **suffix removal** expansion:

```bash
target="${path%."$old"}.$new"
```

`${path%pattern}` deletes the shortest match of `pattern` from the end.
With `.jpeg` that turns `uploads/cover.jpeg` into `uploads/cover`; we then
append `.jpg`. Because only the end is trimmed, `a.txt.txt` becomes
`a.txt.md` correctly. The quotes inside the braces make the extension
literal even if it contains glob characters.

The existence check protects data: `mv` silently replaces its target.

```bash
if [[ -e $target ]]; then ... skipped ...; continue; fi
mv "$path" "$target"
```

To print names without the folder: `${path##*/}` removes everything up to the
last slash (the long-prefix twin of `%`).

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then echo "usage: solution.sh FOLDER OLD NEW" >&2; exit 2; fi
folder=$1; old=$2; new=$3
[[ -d $folder ]] || { echo "no such folder: $folder" >&2; exit 1; }

shopt -s nullglob
renamed=0; skipped=0
for path in "$folder"/*."$old"; do
  [[ -f $path ]] || continue
  target="${path%."$old"}.$new"
  if [[ -e $target ]]; then
    echo "skipped: ${path##*/} -> ${target##*/} already exists"
    skipped=$(( skipped + 1 ))
    continue
  fi
  mv "$path" "$target"
  echo "renamed: ${path##*/} -> ${target##*/}"
  renamed=$(( renamed + 1 ))
done
echo "done: $renamed renamed, $skipped skipped"
```

## Try it by hand

```bash
mkdir pics; touch pics/a.jpeg pics/b.jpeg pics/b.jpg
./solution.sh pics jpeg jpg
ls pics
```

## An alternative

A `rename` command exists, but its syntax is different on every system
(Perl rename on Debian, a different tool on macOS). The loop with `mv` and
`${var%...}` works everywhere and lets you add checks, like the existence
test, that rename tools may not have.

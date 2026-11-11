# Walkthrough: Temporary Files

## The plan

Transform the list into a scratch file, then copy the scratch file over the
original. Name the scratch file with `mktemp` and always delete it.

## Why not edit in place?

Try `sort -u list.txt > list.txt`. Before `sort` runs, the shell opens
`list.txt` for writing and truncates it to zero bytes; `sort` then reads an
empty file. The whole list is gone. Any "read, change, write back" job needs
a second place to put the result.

## Step by step

`mktemp` creates an empty file whose name is random and unused, inside
`$TMPDIR` (or `/tmp`), and prints the path:

```bash
scratch=$(mktemp)
```

A fixed name like `/tmp/list.tmp` is dangerous: two runs at once overwrite
each other, and another user could plant a link at that name. `mktemp`
avoids both.

The cleanup must happen even if the script stops early, so register it
right away:

```bash
trap 'rm -f "$scratch"' EXIT
```

The cleaning pipeline:

```bash
tr 'A-Z' 'a-z' < "$list" | sed '/^[[:space:]]*$/d' | sort -u > "$scratch"
```

`tr` lowercases, `sed '/^[[:space:]]*$/d'` deletes lines that are empty or
only spaces, `sort -u` sorts and removes duplicates. Counting uses
`$(( $(wc -l ...) ))` so macOS padding does not matter.

Finally `cat "$scratch" > "$list"` writes the result back. `cat >` keeps
the list's permissions and ownership, while `mv` would replace the file
with one owned by the script.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then echo "usage: solution.sh LIST" >&2; exit 2; fi
list=$1
if [[ ! -f $list || ! -r $list ]]; then
  echo "cannot read $list" >&2
  exit 1
fi

scratch=$(mktemp)
trap 'rm -f "$scratch"' EXIT

before=$(( $(sed '/^[[:space:]]*$/d' "$list" | wc -l) ))
tr 'A-Z' 'a-z' < "$list" | sed '/^[[:space:]]*$/d' | sort -u > "$scratch"
after=$(( $(wc -l < "$scratch") ))
cat "$scratch" > "$list"

echo "kept $after of $before addresses"
```

## Try it by hand

```bash
printf 'B@x.example\nb@x.example\n\nA@x.example\n' > l.txt
./solution.sh l.txt
cat l.txt
```

## An alternative

`sort -u -o list.txt list.txt` is special: `sort -o` is allowed to name the
same file for input and output. It solves this one job, but the scratch-file
pattern works for any pipeline, such as `tr | sed | sort`.

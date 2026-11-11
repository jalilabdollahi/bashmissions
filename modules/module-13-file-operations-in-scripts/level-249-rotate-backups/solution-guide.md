# Walkthrough: Rotate Backups

## The plan

Make room at the front by moving everything one place back, starting with the
oldest. Then put the fresh copy in the freed first slot.

## Step by step

Think of the slots as `FILE.1` (newest), `FILE.2`, `FILE.3` (oldest). Write
the "before" and "after" for a full set:

| before | after |
|---|---|
| `FILE.3` = three nights ago | gone |
| `FILE.2` = two nights ago | `FILE.3` |
| `FILE.1` = last night | `FILE.2` |
| `FILE` = tonight | copied to `FILE.1` |

Order is everything. Moving `.1` to `.2` first would overwrite `.2` before it
had been moved on. Always free the destination first, so the oldest goes:

```bash
rm -f "$file.3"
```

(`-f` keeps `rm` quiet when it does not exist.) Then shift, oldest to
newest, only what exists:

```bash
for n in 2 1; do
  if [[ -e $file.$n ]]; then
    mv "$file.$n" "$file.$((n + 1))"
  fi
done
```

`$file.$n` builds names like `daily.txt.2`; `$((n + 1))` is arithmetic
inside the name. A missing slot (a gap in the series) is skipped rather than
turned into an error or an empty file. Finally `cp "$file" "$file.1"`.

The count uses the same idea: for each of the three names, add one if the
file exists.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then echo "usage: solution.sh FILE" >&2; exit 2; fi
file=$1
if [[ ! -f $file ]]; then echo "cannot read $file" >&2; exit 1; fi

rm -f "$file.3"
for n in 2 1; do
  if [[ -e $file.$n ]]; then
    mv "$file.$n" "$file.$((n + 1))"
  fi
done
cp "$file" "$file.1"

kept=0
for n in 1 2 3; do
  [[ -e $file.$n ]] && kept=$(( kept + 1 ))
done
echo "rotated $file: $kept backups kept"
```

## Try it by hand

```bash
echo v1 > notes.txt; ./solution.sh notes.txt
echo v2 > notes.txt; ./solution.sh notes.txt
ls notes.txt*; cat notes.txt.2
```

## An alternative

A loop that counts *up* (`1 2 3`) looks natural but destroys data: each
`mv` overwrites the next slot before it has moved. If you ever need an
unlimited history, name copies by date instead and delete the old ones with
`find -mtime`, as in the earlier levels.

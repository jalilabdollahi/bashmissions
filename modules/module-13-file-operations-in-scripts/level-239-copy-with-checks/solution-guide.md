# Walkthrough: Copy with Checks

## The plan

A trustworthy copy has three stages: check the inputs, copy, verify. Every
stage can fail in its own way, and each failure gets its own message and exit
code so the caller can tell them apart.

## Step by step

Stage 1, inputs. Each test is a one-liner with `||` to bail out:

```bash
[[ -f $src && -r $src ]] || { echo "cannot read $src" >&2; exit 1; }
[[ -d $folder ]]         || { echo "no such folder: $folder" >&2; exit 1; }
dest=$folder/$(basename "$src")
[[ ! -e $dest ]]         || { echo "refusing to overwrite $dest" >&2; exit 1; }
```

`basename` strips the folder part of the source (`dumps/db.dump` becomes
`db.dump`), so the copy keeps its name. The overwrite check matters because
plain `cp` replaces an existing file without a word.

Stage 2, copy: `cp "$src" "$dest"`.

Stage 3, verification. `cp` returning 0 only means no error was *noticed*.
`cmp -s` compares both files byte by byte, silently. Status 0 means
identical, 1 means different:

```bash
if ! cmp -s "$src" "$dest"; then
  rm -f "$dest"
  echo "copy of $src is corrupt, removed $dest" >&2
  exit 3
fi
```

Removing the bad copy matters: a half-file in the backup folder is worse than
no file, because someone will trust it later.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh SOURCE FOLDER" >&2
  exit 2
fi
src=$1
folder=$2
[[ -f $src && -r $src ]] || { echo "cannot read $src" >&2; exit 1; }
[[ -d $folder ]]         || { echo "no such folder: $folder" >&2; exit 1; }
dest=$folder/$(basename "$src")
[[ ! -e $dest ]]         || { echo "refusing to overwrite $dest" >&2; exit 1; }

cp "$src" "$dest"
if ! cmp -s "$src" "$dest"; then
  rm -f "$dest"
  echo "copy of $src is corrupt, removed $dest" >&2
  exit 3
fi
echo "copied $src -> $dest"
```

## Try it by hand

```bash
mkdir out; echo data > a.txt
./solution.sh a.txt out
./solution.sh a.txt out ; echo "exit $?"       # refuses
./solution.sh a.txt out2 ; echo "exit $?"     # no such folder
```

## An alternative

`cp -n` ("no clobber") skips existing files, but its exit status and message
differ between macOS and Linux, so an explicit `-e` test is both clearer
and portable. For checksums on big files you could compare `cksum` outputs;
`cmp` is simpler and stops at the first different byte.

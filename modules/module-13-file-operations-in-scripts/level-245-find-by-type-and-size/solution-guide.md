# Walkthrough: Find by Type and Size

## The plan

Three questions asked of the same tree: which files are big, which are
empty, how many folders. Each is one `find` with a different combination of
tests.

## Step by step

**Type.** Every entry has a type: `-type f` is a regular file, `-type d` a
directory. Always say which one you mean. A folder's own size is just the
space for its list of names (often 4096 bytes), so without `-type f` every
folder looks "big".

**Size.** `-size` has a notorious default unit: 512-byte blocks, rounded up,
and BSD and GNU disagree about some suffixes. The **`c`** suffix means plain
bytes and works everywhere. A `+` means "more than", `-` "less than", and no
sign means "exactly":

```bash
find "$folder" -type f -size +"${bytes}"c     # larger than $bytes bytes
find "$folder" -type f -size 0                # empty
```

Both are piped through `sort` and prefixed in a small loop:

```bash
find "$folder" -type f -size +"${bytes}"c | sort | while IFS= read -r path; do
  echo "big: $path"
done
```

**Folders.** `find "$folder" -type d` prints the starting folder too, so the
number of sub-folders is the line count minus one. `wc -l` goes inside
`$(( ))` for macOS.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[0-9]+$ ]]; then
  echo "usage: solution.sh FOLDER BYTES" >&2
  exit 2
fi
folder=$1
bytes=$2
[[ -d $folder ]] || { echo "no such folder: $folder" >&2; exit 1; }

find "$folder" -type f -size +"${bytes}"c | sort | while IFS= read -r path; do
  echo "big: $path"
done
find "$folder" -type f -size 0 | sort | while IFS= read -r path; do
  echo "empty: $path"
done
dirs=$(( $(find "$folder" -type d | wc -l) - 1 ))
echo "folders: $dirs"
```

## Try it by hand

```bash
mkdir -p d/sub; head -c 5000 /dev/zero > d/sub/blob; touch d/empty
./solution.sh d 1000
```

## An alternative

`find "$folder" -type f -empty` is a neat spelling of the empty test, and
`-size +1M` is shorter than a byte count. But `-empty` is not in the
oldest POSIX, and `M` units are rounded to blocks differently on each
system. Bytes with `c` are exact everywhere.

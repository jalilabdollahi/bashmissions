# Walkthrough: Find World-Writable Files

## The plan
Validate the argument, ask `find` for regular files whose "others write" bit is
set, print them sorted, and count them.

## Reading a mode
A mode like `0664` is four octal digits; the last three are owner, group and
others. In each digit, 4 is read, 2 is write and 1 is execute. So the last
digit of the mode is what *everyone else* may do: `6` is read+write, `2` is write
only, `4` is read only.

## find -perm
- `-perm 664` matches only files whose mode is *exactly* 664.
- `-perm -002` matches every file where the others-write bit is set, whatever
  else is set. That is the audit question, and it catches 666, 777, 602 and 664
  with a world-writable twist alike.

Add `-type f` for regular files only (links and folders are excluded).

## Steps
1. Argument checks: usage (exit 2), then `[[ -d $dir ]]` (exit 1).
2. `mapfile -t hits < <(find "$dir" -type f -perm -002 | sort)` reads each
   result into one array element, so spaces in names are safe.
3. Print the elements with a loop and `printf '%s\n'`.
4. Print the count with `${#hits[@]}`.

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
mapfile -t hits < <(find "$dir" -type f -perm -002 | sort)
for path in "${hits[@]}"; do
  printf '%s\n' "$path"
done
printf 'world-writable: %d\n' "${#hits[@]}"
```

## Try it
```
mkdir -p t; touch t/a t/b; chmod 666 t/a
./solution.sh t
```

## Alternative
`find "$dir" -type f -perm -002 -print | sort | tee ...` plus `wc -l` also works,
but `wc -l` pads its number on macOS, and an empty `hits` array makes the count
trivially right.

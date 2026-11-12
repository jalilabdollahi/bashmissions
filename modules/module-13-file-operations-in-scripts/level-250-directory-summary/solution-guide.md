# Walkthrough: Directory Summary

## The plan

Walk all files once. For each, work out its extension and add one to that
extension's counter. At the end print the counters, largest first.

## Step by step

**The loop and the tally.** A counting map is an associative array. The
expression `${count[$ext]:-0}` reads the current value or 0 if the key is
new:

```bash
declare -A count=()
count[$ext]=$(( ${count[$ext]:-0} + 1 ))
```

**Feeding the loop.** `find ... | while read` would run the loop in a
subshell, and everything it counted would be gone afterwards. Reading from
a process substitution keeps the loop in the main shell:

```bash
while IFS= read -r path; do
  ...
done < <(find "$folder" -type f)
```

`IFS= read -r` keeps leading spaces and backslashes in file names intact.

**The extension.** Work on the name, not the path, otherwise a folder called
`v1.2` gives the file `v1.2/readme` the extension "2/readme".

```bash
name=${path##*/}      # strip everything up to the last slash
stem=${name%.*}       # drop the last ".something"
ext=${name##*.}       # keep what follows the last dot
```

Three odd cases fall out of those expansions: no dot at all (`Makefile`:
`ext` equals the whole name), a leading dot (`.gitignore`: the stem is
empty), a trailing dot (`notes.`: the extension is empty). The test
`[[ $name == *.* && -n $stem && -n $ext ]]` catches all three; everything
else is lowercased with `${ext,,}`.

**The table.** Print `ext count` pairs, sort them by the number (descending,
`-k2,2nr`) and then by name (`-k1,1`), and reshape each line:

```bash
for ext in "${!count[@]}"; do printf '%s %d\n' "$ext" "${count[$ext]}"; done \
  | sort -k2,2nr -k1,1 | while read -r ext n; do echo "$ext: $n"; done
```

The `while` after the sort only prints, so a pipe is fine there.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then echo "usage: solution.sh FOLDER" >&2; exit 2; fi
folder=$1
[[ -d $folder ]] || { echo "no such folder: $folder" >&2; exit 1; }

declare -A count=()
total=0
while IFS= read -r path; do
  name=${path##*/}
  stem=${name%.*}
  ext=${name##*.}
  if [[ $name == *.* && -n $stem && -n $ext ]]; then ext=${ext,,}; else ext="(none)"; fi
  count[$ext]=$(( ${count[$ext]:-0} + 1 ))
  total=$(( total + 1 ))
done < <(find "$folder" -type f)

for ext in "${!count[@]}"; do
  printf '%s %d\n' "$ext" "${count[$ext]}"
done | sort -k2,2nr -k1,1 | while read -r ext n; do
  echo "$ext: $n"
done
echo "total: $total files"
```

## Try it by hand

```bash
mkdir -p t/sub; touch t/a.TXT t/b.txt t/sub/c.md t/Makefile t/.env
./solution.sh t
```

## An alternative

A pure-pipeline version, `find ... | sed ... | sort | uniq -c`, needs no
array but is hard to get right for the odd names above and gives you no
place to put the total. The array version names each rule explicitly.

# Walkthrough: Associative Arrays

## The plan
Read the ownership file once into a map from server name to owner, then answer each question with a single lookup. The most important line is the declaration.

## Step by step
1. Keep the usage check, store the file path, and `shift` so `$@` contains only servers to look up.
2. Declare the map: `declare -A owners`. This tells Bash that subscripts are strings. The starter used `owners=()`, which is an ordinary array: there, `owners[dory]` is evaluated as arithmetic, "dory" counts as an unset variable meaning 0, and every owner ends up written to slot 0, the last one wins. All lookups then return the same wrong value.
3. Fill the map with `while read -r server owner; do owners[$server]=$owner; done < "$file"`. The first word goes in `server`; `owner` receives the remainder of the line, spaces included. Assigning to an existing key replaces the value, which is exactly the "last line wins" rule.
4. Look up with `${owners[$s]:-unassigned}`. The `:-` operator supplies a default when the key is missing.
5. Reading with `< "$file"` keeps the loop in your shell so the map survives.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh OWNERFILE [SERVER...]" >&2
  exit 2
fi
file=$1
shift
declare -A owners=()
while read -r server owner; do
  owners[$server]=$owner
done < "$file"
for s in "$@"; do
  echo "$s -> ${owners[$s]:-unassigned}"
done
```

## Trying it by hand
`printf 'dory Priya\neel Dental IT\n' > o.txt; bash solution.sh o.txt eel dory x`.

## An alternative
`grep` for "^dory " in the file each time you ask works for one lookup, but it re-reads the file for every question and cannot overwrite earlier lines. When you query repeatedly, load once into a map.

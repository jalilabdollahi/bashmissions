# Walkthrough: Name References

## The plan
The helper must modify an array that lives in the caller. Functions receive
copies of values, so we pass the array's *name*, and inside the function use a name
reference to act on the real variable.

## Building it
A tiny refresher on arrays: `seen=()` creates an empty list, `seen+=("x")` appends,
`${#seen[@]}` is the number of elements, and `"${seen[@]}"` expands to each element
as a separate word.

The name reference does the magic:

```bash
add_unique() {
  local -n list=$1
```

From here `list` is another name for whatever variable `$1` names. If `$1` is
`seen`, then `list+=("x")` appends to `seen`. Now the dedupe logic: look for the
value, and leave early if found:

```bash
  local value=$2 item
  for item in "${list[@]}"; do
    [[ $item == "$value" ]] && return 0
  done
  list+=("$value")
}
```

`==` inside `[[ ]]` with a quoted right side compares exactly, so `Dory` and `dory`
differ, as the tests require. The main loop passes the name without `$`:

```bash
seen=()
while read -r line; do
  [[ -z $line ]] && continue
  add_unique seen "$line"
done
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
add_unique() {
  local -n list=$1
  local value=$2 item
  for item in "${list[@]}"; do
    [[ $item == "$value" ]] && return 0
  done
  list+=("$value")
}
seen=()
while read -r line; do
  [[ -z $line ]] && continue
  add_unique seen "$line"
done
echo "unique: ${#seen[@]}"
for item in "${seen[@]}"; do
  echo "- $item"
done
```

## Try it by hand
```bash
printf 'dory\neel\ndory\n' | ./solution.sh
```

## Alternative
`sort -u` removes duplicates in a single command, but it changes the order. The
name-reference helper keeps first-seen order and works on any array you name.

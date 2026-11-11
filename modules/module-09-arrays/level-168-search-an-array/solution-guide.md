# Walkthrough: Search an Array

## The plan
Arrays have no `contains` operator. The standard recipe is a loop that compares every element with the name and gives up at the first match. If the loop ends without a match, the answer is no.

## Step by step
1. The starter stores the first argument in `name`, removes it with `shift`, and puts the rest in the array `allowed`. Zero entries is fine: `"${allowed[@]}"` is then an empty list and the loop body never runs.
2. Loop: `for entry in "${allowed[@]}"; do`.
3. Compare with `[[ $entry == "$name" ]]`. Inside `[[ ]]` the left side needs no quotes, but the right side must be quoted. Unquoted, `==` does pattern matching, so `*` would match every entry and `ee?` would match `eel`.
4. On a match print `<name>: allowed` and `exit 0` right there. There is no point looking further.
5. After the loop, the only way to arrive is "no match": print `<name>: denied` and `exit 1`.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME [ENTRY...]" >&2
  exit 2
fi
name=$1
shift
allowed=("$@")
for entry in "${allowed[@]}"; do
  if [[ $entry == "$name" ]]; then
    echo "$name: allowed"
    exit 0
  fi
done
echo "$name: denied"
exit 1
```

## Trying it by hand
`bash solution.sh eel wheelbarrow eel; echo $?` prints allowed and 0. `bash solution.sh eel wheelbarrow reel; echo $?` prints denied and 1.

## An alternative
A famous one-liner is `[[ " ${allowed[*]} " == *" $name "* ]]`. It joins the list with spaces and does a substring match around the name. It is short, but it breaks on entries that contain spaces (the "marlin octopus" test) and on names with glob characters. The loop is longer and always right.

# Walkthrough: Return Data on stdout

## The plan
Two jobs: a function that turns a name into an address by *printing* it, and a
loop that catches that output and formats the report line.

## Building it
Start with the cleanup on a single value. `tr 'A-Z ' 'a-z-'` lowercases and
swaps each space for a hyphen. `tr -cd 'a-z0-9-'` then deletes (`-d`) every
character that is not (`-c`, complement) in the allowed set:

```bash
printf '%s' "Gull & Anchor Pub" | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-'
# gull--anchor-pub
```

Note the double hyphen: the `&` was removed but both neighbouring spaces had
already become hyphens. The tests expect exactly that.

Wrap it in a function that prints the finished address:

```bash
domain_for() {
  local slug
  slug=$(printf '%s' "$1" | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-')
  printf '%s.lanternfish.example\n' "$slug"
}
```

Then capture the output where you call it:

```bash
for name in "$@"; do
  address=$(domain_for "$name")
  echo "$name -> $address"
done
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
domain_for() {
  local slug
  slug=$(printf '%s' "$1" | tr 'A-Z ' 'a-z-' | tr -cd 'a-z0-9-')
  printf '%s.lanternfish.example\n' "$slug"
}
for name in "$@"; do
  address=$(domain_for "$name")
  echo "$name -> $address"
done
```

## Try it by hand
```bash
./solution.sh "Harbour Bakery" "Gull & Anchor Pub"
```

## Alternative
Without capturing, the function could print directly and the loop would just call
it, but then you could never reuse the address for anything else (a DNS record, a
folder name). Returning data on stdout keeps the function a pure "name in,
address out" tool.

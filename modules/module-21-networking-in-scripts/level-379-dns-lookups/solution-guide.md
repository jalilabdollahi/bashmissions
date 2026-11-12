# Walkthrough: DNS Lookups

## The plan
One `dig +short` per name. Separate three outcomes: dig failed, dig worked but produced no addresses, and dig returned addresses. Keep a counter of the bad ones for the exit status.

## Steps
1. Usage check for empty argument lists.
2. Run dig inside `if !` so a failure (exit 9 when no resolver answers) is handled instead of aborting:
   ```bash
   if ! answers=$(dig +short "$name" 2>/dev/null); then
     echo "$name -> lookup failed"
     bad=$((bad + 1))
     continue
   fi
   ```
3. A name that does not exist is not a dig failure; the output is just empty. Aliases show up as lines such as `shop.lanternfish.example.`, which are not addresses, so filter:
   ```bash
   addrs=$(printf '%s\n' "$answers" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | paste -sd, - || true)
   ```
   `paste -sd, -` turns many lines into one comma-separated line.
4. Empty `addrs` means no answer. Print the line either way and count the bad ones.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh NAME..." >&2
  exit 2
fi

bad=0
for name in "$@"; do
  if ! answers=$(dig +short "$name" 2>/dev/null); then
    echo "$name -> lookup failed"
    bad=$((bad + 1))
    continue
  fi
  addrs=$(printf '%s\n' "$answers" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | paste -sd, - || true)
  if [[ -z $addrs ]]; then
    echo "$name -> no answer"
    bad=$((bad + 1))
  else
    echo "$name -> $addrs"
  fi
done

if (( bad > 0 )); then
  exit 1
fi
```

## Try it by hand
```
./solution.sh www.harbourbakery.example mail.tidewater.example
dig www.harbourbakery.example          # the long form you are avoiding
```

## Alternative
`dig +short NAME A` states the record type explicitly (A is the default). Asking for `AAAA` or `MX` is the same script with another type, though MX lines also contain a priority number that needs parsing.

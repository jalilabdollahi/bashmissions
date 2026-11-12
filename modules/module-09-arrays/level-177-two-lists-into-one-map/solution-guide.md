# Walkthrough: Two Lists into One Map

## The plan
Zipping means pairing the first element of one list with the first of the other, and so on. Arrays do this with one shared index; the map then lets you look up an address by host name.

## Step by step
1. `mapfile -t hosts < "$1"` and `mapfile -t ips < "$2"` load the two files, one line per element.
2. Check the lengths before doing anything else. If `${#hosts[@]}` differs from `${#ips[@]}`, print the message to stderr and `exit 1`. If you skipped this, a missing address would silently shift every following pair by one.
3. `declare -A table=()` creates the map. The `=()` gives an empty but defined map, so it works under `set -u` even when the files are empty.
4. Walk the indexes of one array and use the same index in the other: `table[${hosts[i]}]=${ips[i]}`. The host text is the key and, because later assignments overwrite earlier ones, a repeated host ends with its last address.
5. Sort the keys, not the finished lines: `printf '%s\n' "${!table[@]}" | sort`. Sorting whole `host=ip` lines compares the `=` against the next character of the longer name, so `dory2=...` would come before `dory=...`. Sorting bare keys gives `dory`, then `dory2`.
6. Load the sorted keys with `mapfile -t names < <(...)` and print `$h=${table[$h]}` for each. Guard the empty table.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOSTFILE IPFILE" >&2
  exit 2
fi
mapfile -t hosts < "$1"
mapfile -t ips < "$2"
if (( ${#hosts[@]} != ${#ips[@]} )); then
  echo "lists differ in length: ${#hosts[@]} hosts, ${#ips[@]} addresses" >&2
  exit 1
fi
declare -A table=()
for i in "${!hosts[@]}"; do
  table[${hosts[i]}]=${ips[i]}
done
if (( ${#table[@]} > 0 )); then
  mapfile -t names < <(printf '%s\n' "${!table[@]}" | sort)
  for h in "${names[@]}"; do
    echo "$h=${table[$h]}"
  done
fi
```

## Trying it by hand
`printf 'a\nb\n' > h; printf '1\n2\n' > i; bash solution.sh h i`. Then delete a line from `i` and run again.

## An alternative
`paste -d= hosts.txt ips.txt | sort` zips the files with a standard tool and is perfect on the command line. It does not check lengths (paste pads silently), cannot enforce "later wins", and gives you text, not a map you can query inside the script.

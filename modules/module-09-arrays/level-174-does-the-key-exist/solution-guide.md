# Walkthrough: Does the Key Exist?

## The plan
The starter already parses the file into a map. Your job is the lookup, which must tell three situations apart. The key point is that "the key exists" and "the value is non-empty" are separate facts.

## Step by step
1. Look at the parser first. Lines that are empty, start with `#`, or have no `=` are skipped with `continue`. For the others, `${line%%=*}` is the key and `${line#*=}` is the value, split at the first `=`. A line like `motd=` stores an empty string under `motd`, which is a real, existing entry.
2. The starter's lookup `${settings[$key]:-(not set)}` replaces an empty value as well as a missing one, so `motd` is reported as not set. That is the bug Theo had.
3. Ask existence directly: `[[ -v settings[$key] ]]`. It is true for a key that is present, whatever its value. Negate it for the "not set" branch.
4. In the second branch the key exists, so test the value: `[[ -z ${settings[$key]} ]]` means empty.
5. Everything else prints the value.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FILE [KEY...]" >&2
  exit 2
fi
file=$1
shift
declare -A settings=()
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line || $line == \#* || $line != *=* ]] && continue
  settings[${line%%=*}]=${line#*=}
done < "$file"
for key in "$@"; do
  if [[ ! -v settings[$key] ]]; then
    echo "$key: (not set)"
  elif [[ -z ${settings[$key]} ]]; then
    echo "$key: (empty)"
  else
    echo "$key: ${settings[$key]}"
  fi
done
```

## Trying it by hand
`printf 'a=\nb=2\n' > t.conf; bash solution.sh t.conf a b c` prints empty, 2 and not set.

## An alternative
`${settings[$key]+x}` expands to `x` if the key exists (even empty) and to nothing otherwise. It works on old Bash versions and in POSIX-style scripts, but `[[ -v ]]` reads much more clearly.

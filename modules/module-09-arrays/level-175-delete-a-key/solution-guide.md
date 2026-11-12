# Walkthrough: Delete a Key

## The plan
Load the roster, remove each revoked login only if it exists, count the real removals, and print what is left in a stable order.

## Step by step
1. The starter loads the file and splits each line at the first `=`.
2. Look at its revoke loop: `roster[$login]=""` blanks the value but keeps the key, so the login still appears in `${!roster[@]}`. For Priya's next script that means the revoked user is still valid. Replace it with a real removal.
3. Test first: `if [[ -v roster[$login] ]]; then`. This is the key-existence test from the previous level. It is what makes "ghost" count for nothing and makes the second `noor` count for nothing, because by then the key is gone.
4. Remove with `unset 'roster[$login]'`. Single quotes stop the shell from interpreting the brackets as a filename pattern; Bash itself still expands `$login` inside the subscript. Then `revoked=$(( revoked + 1 ))`.
5. Print `revoked: N`. Then print the survivors: sort the keys with `printf '%s\n' "${!roster[@]}" | sort` and read them with `while IFS= read -r login; ... done < <(...)`, printing `$login=${roster[$login]}`. Guard the empty map.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh ROSTER [LOGIN...]" >&2
  exit 2
fi
file=$1
shift
declare -A roster=()
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line ]] && continue
  roster[${line%%=*}]=${line#*=}
done < "$file"
revoked=0
for login in "$@"; do
  if [[ -v roster[$login] ]]; then
    unset 'roster[$login]'
    revoked=$(( revoked + 1 ))
  fi
done
echo "revoked: $revoked"
if (( ${#roster[@]} > 0 )); then
  while IFS= read -r login; do
    echo "$login=${roster[$login]}"
  done < <(printf '%s\n' "${!roster[@]}" | sort)
fi
```

## Trying it by hand
`printf 'a=1\nb=2\n' > r.txt; bash solution.sh r.txt a a z` prints `revoked: 1` and `b=2`.

## An alternative
`unset` on a missing key is harmless, so you could drop the `-v` test and compare the map's size before and after to compute the count. Testing first is more direct and says what you mean.

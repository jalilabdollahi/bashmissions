# Walkthrough: Slices

## The plan
Once the machines are in an array, the wave is a single slice expansion. The rest of the script is argument handling and making sure an empty wave prints nothing.

## Step by step
1. The starter validates the arguments, stores `offset` and `size`, and uses `shift 2` so that only machine names remain in `$@`.
2. Put the machines into an array: `machines=("$@")`.
3. Slice it: `"${machines[@]:offset:size}"`. The syntax is `array[@]:start:count`. Inside a slice Bash evaluates `offset` and `size` as arithmetic, so you do not even need the dollar signs.
4. If fewer elements remain than you asked for, Bash returns what exists. If the start is past the end, the result is empty. Neither is an error.
5. A negative start counts from the end of the array. With the variable `offset=-2` this works as expected. (Writing a literal `${a[@]:-2}` would be misread as the default-value operator, which is why a space or a variable is needed.)
6. Capture the slice in an array `wave=(...)`, test its length, and print with `printf '%s\n'` only if it is not empty. An empty `printf '%s\n'` would still print a blank line.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh OFFSET SIZE [MACHINE...]" >&2
  exit 2
fi
offset=$1
size=$2
shift 2
machines=("$@")
wave=("${machines[@]:offset:size}")
if (( ${#wave[@]} > 0 )); then
  printf '%s\n' "${wave[@]}"
fi
```

## Trying it by hand
`bash solution.sh 1 2 a b c d` prints b and c. `bash solution.sh -2 2 a b c d` prints c and d.

## An alternative
You could use `"${@:offset+1:size}"` directly on the positional parameters, but note that `$@` is numbered from 1 and `$0` counts, which is easy to get wrong. A real array has predictable indexes.

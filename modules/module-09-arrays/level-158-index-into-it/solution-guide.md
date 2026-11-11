# Walkthrough: Index into It

## The plan
Collect the arguments in an array, then pick out three elements by position: the first, the third and the last. The only real trick is knowing how positions are numbered.

## Step by step
1. The usage check is already in the starter. It guarantees at least three machines, so index 2 always exists.
2. Copy every argument into an array: `rack=("$@")`. The quoted `"$@"` hands over each argument as a separate word, so `"marlin two"` stays a single element.
3. Read an element with `${rack[N]}`. The curly braces are required: `$rack[2]` would print the first element followed by the text `[2]`.
4. Indexes start at 0, so top is `[0]` and "third" is `[2]`.
5. The bottom is the last element. You could compute `${rack[${#rack[@]}-1]}`, but Bash 4.3 and later accept a negative index that counts from the end: `${rack[-1]}` is the last, `${rack[-2]}` the one before.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh MACHINE MACHINE MACHINE..." >&2
  exit 2
fi
rack=("$@")
echo "top: ${rack[0]}"
echo "third: ${rack[2]}"
echo "bottom: ${rack[-1]}"
```

## Trying it by hand
`bash solution.sh a b c d e` should print `top: a`, `third: c`, `bottom: e`. Then run it with exactly three arguments and notice that third and bottom are the same machine.

## An alternative
You can skip the array and use `$1`, `$3` and `${@: -1}`. That works for arguments, but an array can be passed around, copied and changed, while `$@` cannot be modified freely. Practising on a real array prepares you for data that does not come from the command line.

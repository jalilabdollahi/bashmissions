# Walkthrough: Reverse a String

## The plan
Start at the last character, step backwards to the first, and add each character
to a growing result.

## Positions
A string of length `N` has characters at positions `0` to `N-1`. For `abc` that is
`a` at 0, `b` at 1, `c` at 2. `${token:i:1}` picks the single character at position
`i`. Inside the substring expansion, `i` is evaluated as arithmetic, so no `$` is
needed.

## The loop
A C-style `for` loop gives full control over the counting. Start at the last
position and decrease until the index passes 0:

```bash
for (( i = ${#token} - 1; i >= 0; i-- )); do
  decoded+=${token:i:1}
done
```

For an empty token, `${#token} - 1` is `-1`, the condition `i >= 0` is false at
once and the loop body never runs, so the result stays empty. No special case.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
token=${1-}
decoded=""
for (( i = ${#token} - 1; i >= 0; i-- )); do
  decoded+=${token:i:1}
done
echo "$decoded"
```

## Try it by hand
```bash
./solution.sh 321cba
./solution.sh "!dlrow olleh"
./solution.sh ""
```

## Alternative
`rev <<< "$token"` does it in one command and is perfectly fine in everyday
work, but it is not part of POSIX and may be missing on minimal systems, like the
migration host in this story. Writing the loop once also shows how to go through
a string character by character, which is useful for many other jobs (counting
vowels, validating each character, and so on).

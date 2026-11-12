# Walkthrough: Validate an IPv4 Address

## The plan
Two checks, each with the right tool.
1. **Shape** (regex): four groups of one to three digits, separated by dots.
2. **Range** (arithmetic): every group is at most 255.

Why not do it all in the regex? You can: `25[0-5]|2[0-4][0-9]|1?[0-9]{1,2}` per
octet. It works, but it is hard to read and easy to get wrong. Splitting the
job keeps each part obvious.

## Step 1: the shape
```bash
re='^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$'
```
This rejects `1.2.3`, `1.2.3.4.5`, `1..3.4`, `1234.1.1.1`, letters, and any
space, because of the anchors and the classes. It still lets `256.1.1.1` through.

## Step 2: the range
After a match, `${BASH_REMATCH[@]:1:4}` is the slice of the four groups (a slice
of an array, as in module 9). Compare each one:

```bash
for octet in "${BASH_REMATCH[@]:1:4}"; do
  (( 10#$octet > 255 )) && ok=no
done
```

The `10#` prefix is essential. A number with a leading zero is *octal* in Bash
arithmetic: `08` is an error and `010` is 8. `10#08` is plain decimal 8.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$'
while IFS= read -r addr || [[ -n $addr ]]; do
  ok=yes
  if [[ $addr =~ $re ]]; then
    for octet in "${BASH_REMATCH[@]:1:4}"; do
      if (( 10#$octet > 255 )); then ok=no; fi
    done
  else
    ok=no
  fi
  [[ $ok == yes ]] && echo "$addr valid" || echo "$addr invalid"
done
```

## Try it by hand
```bash
printf '10.0.0.1\n256.1.1.1\n10.08.09.1\n' | ./solution.sh
```

## Alternative
Split with `IFS=. read -r a b c d` and test each number with a regex. It also
works, but it cannot tell `1.2.3.4.5` from `1.2.3.4`, because `read` puts the
tail into the last variable.

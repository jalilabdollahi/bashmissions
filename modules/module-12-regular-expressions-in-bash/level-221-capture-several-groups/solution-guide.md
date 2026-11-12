# Walkthrough: Capture Several Groups

## The plan
Describe the entire tag in one regex, mark the three numbers with parentheses,
and print them from the array.

## The regex, piece by piece
| piece | regex |
|---|---|
| start and the letter v | `^v` |
| major | `([0-9]+)` |
| a real dot | `\.` |
| minor | `([0-9]+)` |
| a real dot | `\.` |
| patch | `([0-9]+)` |
| end | `$` |

The dots must be escaped. A bare `.` matches *any* character, so `v1x2x3` would
sneak through otherwise.

## The numbering
The groups are counted by the position of their opening parenthesis, left to
right: the first `(` is group 1, the second group 2, the third group 3. Element
`0` is the whole tag.

## Bad tags
`v2.14` has only two numbers and `v2.14.3.4` has four; with both anchors in
place neither fits. Everything that fails the test goes to the `else` branch, so
`BASH_REMATCH` is never read for a bad line.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^v([0-9]+)\.([0-9]+)\.([0-9]+)$'
while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "major=${BASH_REMATCH[1]} minor=${BASH_REMATCH[2]} patch=${BASH_REMATCH[3]}"
  else
    echo "bad tag: $tag"
  fi
done
```

## Try it by hand
```bash
printf 'v2.14.3\nv2.14\n' | ./solution.sh
```

## Alternative
Strip the `v` with `${tag#v}` and split on the dots with `IFS=. read -r a b c`.
It works for clean input, but the regex also *validates* the shape in the same
step, so the script cannot be fooled by `v1.two.3`.

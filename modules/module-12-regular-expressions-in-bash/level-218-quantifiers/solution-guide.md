# Walkthrough: Quantifiers

## The plan
Write the reference as a sequence of parts, and give each part a *count*.

| part | regex | count |
|---|---|---|
| team prefix | `[A-Z]+` | one or more |
| dash | `-` | exactly one |
| number | `[0-9]{3,5}` | three to five |
| priority | `(-P[0-9])?` | zero or one |
| trailing spaces | `[ ]*` | zero or more |

Put `^` in front and `$` at the end so nothing else can hide around it.

## Why the group
`-P[0-9]` is three characters. A quantifier only applies to the item right
before it, so `-P[0-9]?` would make only the digit optional. Parentheses turn the
three characters into one item, and then `?` can apply to all of them.

## The spaces
A bare space is easy to miss in a regex, so `[ ]*` (a class with one space) makes
it visible. The `*` accepts zero spaces too, so a clean reference is fine.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^[A-Z]+-[0-9]{3,5}(-P[0-9])?[ ]*$'
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "$line: valid"
  else
    echo "$line: invalid"
  fi
done
```

## Try it by hand
```bash
printf 'SEC-123\nSEC-12\nSEC-1234-P2\n' | ./solution.sh
```

## Alternative
You could split the line into parts with parameter expansion and test each one.
It works, but it is longer and harder to change than one regex that states the
whole format in a single line.

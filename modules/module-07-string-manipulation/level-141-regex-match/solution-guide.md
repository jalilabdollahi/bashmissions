# Walkthrough: Regex Match

## The plan
Describe the valid shape once as a regular expression, then test each line against
it.

## Building the regex
Say it in words, then translate piece by piece:

| words | regex |
|---|---|
| start of the line | `^` |
| an optional `v` | `v?` |
| one or more digits | `[0-9]+` |
| a dot | `\.` |
| (repeat) minor and patch | `[0-9]+\.[0-9]+` |
| end of the line | `$` |

Put together: `^v?[0-9]+\.[0-9]+\.[0-9]+$`.

The dot needs the backslash, because in a regex a bare `.` means "any character",
and `1-4-2` or `1a4b2` would sneak through. The anchors `^` and `$` matter too:
without them `1.4.2-rc1` contains a valid-looking `1.4.2` and would pass.

## Testing in Bash
`[[ $tag =~ $re ]]` is true when the regex matches somewhere in `$tag`. Keeping the
regex in a variable and leaving it **unquoted** on the right is the safest style:
quoting it would turn it into literal text.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^v?[0-9]+\.[0-9]+\.[0-9]+$'
while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "$tag: valid"
  else
    echo "$tag: invalid"
  fi
done
```

## Try it by hand
```bash
printf '1.4.2\nv2.0.10\n1.4\n1.4.2-rc1\n' | ./solution.sh
```

## Alternative
`grep -E '^v?[0-9]+(\.[0-9]+){2}$'` accepts the same tags. The built-in `=~` avoids
a process per tag, and, as the next level shows, it hands you the matched parts too.

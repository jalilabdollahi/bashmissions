# Walkthrough: Character Classes

## The plan
Describe the tag position by position, anchor it, and test every line.

## Building the regex
A tag like `rack-b07` has four parts:

| part | regex |
|---|---|
| start of line | `^` |
| the literal text | `rack-` |
| one lowercase letter | `[a-z]` |
| first digit | `[[:digit:]]` |
| second digit | `[[:digit:]]` |
| end of line | `$` |

A bracket expression matches exactly one character. `[a-z]` is a range, and
`[[:digit:]]` is a named class (the double brackets are one pair for the class
syntax and one pair for the name). With `LC_ALL=C` `[a-z]` means the 26
lowercase ASCII letters; in some locales ranges can behave oddly, so named
classes such as `[[:lower:]]` are the more robust habit.

Joined together: `^rack-[a-z][[:digit:]][[:digit:]]$`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^rack-[a-z][[:digit:]][[:digit:]]$'
while IFS= read -r tag || [[ -n $tag ]]; do
  if [[ $tag =~ $re ]]; then
    echo "$tag: ok"
  else
    echo "$tag: bad"
  fi
done
```

## Try it by hand
```bash
printf 'rack-b07\nrack-B07\nrack-b7\n' | ./solution.sh
```

## Alternative
`[0-9]` works exactly like `[[:digit:]]`. Prefer the named class when you want
to be explicit; use `[0-9]` when the range reads better. What you must avoid is
`\d`: it works in some tools, but it is not part of POSIX extended regexes.

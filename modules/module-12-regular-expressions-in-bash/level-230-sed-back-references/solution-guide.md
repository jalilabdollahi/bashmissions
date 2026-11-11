# Walkthrough: sed Back-References

## The plan
Describe a date with three capture groups, then rebuild it in the new order in
the replacement.

## The pattern
```
([0-9]{2})/([0-9]{2})/([0-9]{4})
```
Three groups: `\1` is the day, `\2` the month, `\3` the year. The slashes between
them are plain text. Because the pattern needs exactly two, two and four digits,
`7/11/2024` and `07/11/24` are not dates here and stay untouched.

## The replacement
```
\3-\2-\1
```
Year, a dash, month, a dash, day. The replacement is not a regex, but it
understands `\1` to `\9` (the groups) and `&` (the whole match).

## The delimiter and the flag
The date uses slashes, which would clash with sed's usual delimiter. Using `|`
avoids backslashes: `s|...|...|g`. The `g` flag handles lines holding two dates.

## sed -E
`-E` selects extended regex: `( )`, `{2}`, `|` and `+` work without backslashes.
Both macOS and GNU sed support `-E`; the older `-r` is GNU only.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sed -E 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3-\2-\1|g'
```

## Try it by hand
```bash
echo 'paid 07/11/2024 and 15/12/2024' | ./solution.sh
```

## Alternative
A Bash loop with `[[ =~ ]]` and `BASH_REMATCH` can also reorder a date, but it must
find and replace each date inside the line by hand. `sed` is built to replace
every match in a stream, and it does so in a single command.

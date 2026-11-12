# Walkthrough: Capture Groups

## The plan
Write one regex that describes the request part and the status, wrap the three
interesting parts in parentheses, and read them back after the match.

## Building the regex
The part of the line that matters looks like `"GET /shop/cart HTTP/1.1" 502 `:

| piece | regex | captured? |
|---|---|---|
| opening quote | `"` | no |
| method | `([A-Z]+)` | group 1 |
| space, then path | ` ([^ ]+)` | group 2 |
| protocol | ` HTTP/[0-9.]+` | no |
| closing quote, space | `" ` | no |
| status, exactly 3 digits | `([0-9]{3})` | group 3 |
| space after the status | ` ` | no |

`[^ ]+` means "one or more characters that are not a space", the natural way to
describe a path or URL. The regex is not anchored: it searches inside the line,
which is exactly what we want because the front of the line (address, date) is
irrelevant here.

## Reading the groups
When `[[ $line =~ $re ]]` succeeds, Bash fills the array `BASH_REMATCH`:
index 0 is the whole matched text; 1, 2, 3 are the groups in order of their
opening parenthesis.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='"([A-Z]+) ([^ ]+) HTTP/[0-9.]+" ([0-9]{3}) '
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "${BASH_REMATCH[3]} ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
  else
    echo "skipped: $line"
  fi
done
```

## Try it by hand
```bash
echo '203.0.113.7 - [07/Nov/2024:09:30:15] "GET /shop/cart HTTP/1.1" 502 1432' | ./solution.sh
echo 'not a request' | ./solution.sh
```

## Alternative
`sed -E 's/.*"([A-Z]+) ([^ ]+) HTTP[^"]*" ([0-9]{3}) .*/\3 \1 \2/'` extracts the same
fields, but it prints unmatched lines unchanged instead of telling you they were
skipped, and starts a process. With `=~` the match and the decision to skip are one `if`.

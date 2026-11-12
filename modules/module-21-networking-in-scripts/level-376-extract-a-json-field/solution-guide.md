# Walkthrough: Extract a JSON Field

## The plan
Fetch the record, then run one `sed` substitution that keeps only the value that follows `"FIELD":`. If nothing is captured, the field does not exist.

## Steps
1. Argument check, then fetch with `-sS --fail`. A 404 makes curl fail (exit 22), which we turn into `customer not found: ID`. The `2>/dev/null` keeps curl's own message out of the way.
2. The pattern, read left to right:
   - `.*` skips everything before the key;
   - `"FIELD":` the quoted key and colon. Including the quotes means `"id"` can never match inside `"customer_id"`;
   - ` *` allows spaces after the colon (some servers pretty-print);
   - `"?` swallows an opening quote if the value is a string;
   - `([^",}]*)` captures characters up to the next quote, comma or closing brace;
   - `.*` swallows the rest.
   ```bash
   value=$(printf '%s\n' "$json" | sed -nE 's/.*"'"$field"'": *"?([^",}]*).*/\1/p')
   ```
   `-n` plus the `p` flag prints only when the substitution matched, so a missing field gives an empty string.
3. Empty means not found: message on stderr, exit 1. Otherwise print.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh ID FIELD" >&2
  exit 2
fi
id=$1
field=$2

if ! json=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id" 2>/dev/null); then
  echo "customer not found: $id" >&2
  exit 1
fi

value=$(printf '%s\n' "$json" | sed -nE 's/.*"'"$field"'": *"?([^",}]*).*/\1/p')

if [[ -z $value ]]; then
  echo "field not found: $field" >&2
  exit 1
fi
printf '%s\n' "$value"
```

## Try it by hand
```
./solution.sh c-204 plan
./solution.sh c-310 id
./solution.sh c-204 email; echo "exit=$?"
```

## Alternative
`grep -o '"plan": *"[^"]*"'` isolates `"plan":"pro"`, and a second `sed` trims the key. Two steps instead of one, but easier to read when the capture group looks scary.

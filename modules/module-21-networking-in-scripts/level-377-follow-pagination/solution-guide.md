# Walkthrough: Follow Pagination

## The plan
Use a loop whose condition is "there is another page". Inside it: fetch, print, count, and read the next pointer from the reply. Add a hard page limit so a faulty server cannot keep you forever.

## Steps
1. `next="?page=1"` is the first page. `while [[ -n $next ]]` keeps going until something sets it to empty.
2. Check the limit before fetching: if `pages` has reached 10, report and exit 1.
3. Fetch `$base$next` with `-sS --fail`. On failure print `failed to fetch URL` (stderr) and exit 1; the ids printed so far stay on stdout.
4. Pull the ids with `grep -oE '"inv-[0-9]+"' | tr -d '"'`. `grep` exits 1 when there are none (an empty page), so add `|| true`. Add the number of lines to `total`.
5. Read the new pointer with sed. The pattern needs the value in quotes, so `"next":null` simply does not match and `next` becomes empty, ending the loop.
6. After the loop print the total.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER_ID" >&2
  exit 2
fi
base="https://billing.lanternfish.example/api/v1/customers/$1/invoices"

next="?page=1"
pages=0
total=0
while [[ -n $next ]]; do
  if (( pages >= 10 )); then
    echo "too many pages (limit 10)" >&2
    exit 1
  fi
  pages=$((pages + 1))

  url=$base$next
  if ! page=$(curl -sS --fail "$url" 2>/dev/null); then
    echo "failed to fetch $url" >&2
    exit 1
  fi

  ids=$(printf '%s\n' "$page" | grep -oE '"inv-[0-9]+"' | tr -d '"' || true)
  if [[ -n $ids ]]; then
    printf '%s\n' "$ids"
    total=$((total + $(printf '%s\n' "$ids" | wc -l)))
  fi

  next=$(printf '%s\n' "$page" | sed -nE 's/.*"next": *"([^"]*)".*/\1/p')
done

echo "total: $total"
```

## Try it by hand
```
./solution.sh c-204
cat .calls.log       # one line per page requested
./solution.sh c-666  # the self-pointing server
```

## Alternative
Collect all ids into a file or array and print them at the end. That uses more memory and delays output; printing page by page lets the first results appear at once and keeps partial progress when a later page fails.

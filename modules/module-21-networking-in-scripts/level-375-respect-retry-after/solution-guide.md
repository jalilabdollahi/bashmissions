# Walkthrough: Respect Retry-After

## The plan
A bounded retry loop. Each round: call the API, keep headers, body and status code apart; on 429 read how long the server wants us to wait, sleep exactly that, and go again. Stop after four rounds.

## Steps
1. Make two temp files and clean them with a trap.
2. In the loop, one curl call gives you everything:
   ```bash
   code=$(curl -s -D "$headers" -o "$body" -w '%{http_code}' "$url")
   ```
3. On 200, print the body and exit. Anything other than 200 or 429 is a real error: report it, no retry.
4. On 429, read the header. The raw line looks like `Retry-After: 3` followed by a carriage return, and some servers send it in lowercase:
   ```bash
   wait_for=$(grep -i '^retry-after:' "$headers" | tr -d '\r' | cut -d: -f2 | tr -d ' ' || true)
   ```
   `grep -i` ignores case, `tr -d '\r'` strips the invisible character that would break the number, and `|| true` stops `pipefail` from aborting when the header is absent. Fall back to 1 when the result is not a number.
5. Sleep only if another attempt follows. After the loop, report that you gave up.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

url=https://reports.lanternfish.example/api/v1/monthly
max_attempts=4
headers=$(mktemp)
body=$(mktemp)
trap 'rm -f "$headers" "$body"' EXIT

for (( attempt = 1; attempt <= max_attempts; attempt++ )); do
  code=$(curl -s -D "$headers" -o "$body" -w '%{http_code}' "$url")
  case $code in
    200) cat "$body"; exit 0 ;;
    429)
      wait_for=$(grep -i '^retry-after:' "$headers" | tr -d '\r' | cut -d: -f2 | tr -d ' ' || true)
      [[ $wait_for =~ ^[0-9]+$ ]] || wait_for=1
      if (( attempt < max_attempts )); then sleep "$wait_for"; fi
      ;;
    *) echo "unexpected HTTP $code" >&2; exit 1 ;;
  esac
done

echo "still rate limited after $max_attempts attempts" >&2
exit 1
```

## Try it by hand
```
FAKE_429_AFTERS="3 1" ./solution.sh
cat .calls.log      # every request and every requested sleep, in order
```

## Alternative
`curl -i` puts headers and body in one stream; you then split at the first blank line. Saving headers separately with `-D` is simpler and cannot confuse a body that happens to contain the word Retry-After.

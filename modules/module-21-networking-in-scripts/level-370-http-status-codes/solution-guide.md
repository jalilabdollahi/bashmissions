# Walkthrough: HTTP Status Codes

## The plan
For each URL: make a request, ignore the page, keep only the three-digit status. Count the bad ones, print a summary, and use the exit status to tell the caller whether anything was wrong.

## Steps
1. No arguments means nothing to check, so answer with a usage line on stderr and exit 2.
2. Ask curl for just the code:
   ```bash
   code=$(curl -s -o /dev/null -w '%{http_code}' "$url")
   ```
   `-o /dev/null` sends the body away. `-w '%{http_code}'` prints the code at the very end of the transfer, so it is the only thing left on stdout.
3. When the name cannot be resolved there is no HTTP answer at all. curl prints `000` for that case and exits non-zero. Under `set -e` that would stop the loop at the first dead host, so append `|| true`; the `000` is still captured.
4. Classify with `case`: `000` and everything from 400 to 599 is a problem. 3xx redirects are not.
5. After the loop print `problems: N` and exit 1 when N is positive.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh URL..." >&2
  exit 2
fi

problems=0
for url in "$@"; do
  code=$(curl -s -o /dev/null -w '%{http_code}' "$url") || true
  printf '%s %s\n' "$code" "$url"
  case $code in
    000|[45][0-9][0-9]) problems=$((problems + 1)) ;;
  esac
done

echo "problems: $problems"
if (( problems > 0 )); then
  exit 1
fi
```

## Try it by hand
```
./solution.sh https://www.gullandanchor.example/ https://old.tidewater.example/books
FAKE_DOWN=docs.lanternfish.example ./solution.sh https://docs.lanternfish.example/ping
```

## Alternative
`curl -s -I URL` (a HEAD request) and then reading the first line of the headers also gives the code. It needs text parsing, and some servers answer HEAD differently from GET, so `-w '%{http_code}'` is the cleaner tool.

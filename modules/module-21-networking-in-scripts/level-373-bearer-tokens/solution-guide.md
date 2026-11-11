# Walkthrough: Bearer Tokens

## The plan
Read the secret from the environment, put it into exactly one place (the `Authorization` header), look at the status code, and make sure nothing else ever prints it.

## Steps
1. Refuse to run without a token. Under `set -u` a plain `$LF_TOKEN` would abort with a confusing message, so use the default form:
   ```bash
   if [[ -z ${LF_TOKEN:-} ]]; then
     echo "LF_TOKEN is not set" >&2
     exit 2
   fi
   ```
2. Make a temporary file for the body and register cleanup with `trap`:
   ```bash
   body_file=$(mktemp)
   trap 'rm -f "$body_file"' EXIT
   ```
3. Call the API. `-o` stores the body, `-w` prints the code; the header uses double quotes so the variable expands:
   ```bash
   code=$(curl -s -o "$body_file" -w '%{http_code}' \
     -H "Authorization: Bearer $LF_TOKEN" \
     https://billing.lanternfish.example/api/v1/balance) || code=000
   ```
4. Branch on the code with `case`. 200 prints the balance, 401 and everything else go to stderr with exit 1.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ -z ${LF_TOKEN:-} ]]; then
  echo "LF_TOKEN is not set" >&2
  exit 2
fi

body_file=$(mktemp)
trap 'rm -f "$body_file"' EXIT

code=$(curl -s -o "$body_file" -w '%{http_code}' \
  -H "Authorization: Bearer $LF_TOKEN" \
  https://billing.lanternfish.example/api/v1/balance) || code=000

case $code in
  200) printf 'balance: %s\n' "$(cat "$body_file")" ;;
  401) echo "billing rejected the token" >&2; exit 1 ;;
  *)   echo "unexpected HTTP $code" >&2; exit 1 ;;
esac
```

## Try it by hand
```
LF_TOKEN=tok_live_demo ./solution.sh
LF_TOKEN=tok_expired_demo ./solution.sh; echo "exit=$?"
./solution.sh; echo "exit=$?"
```

## Alternative
Reading the token from a file (`LF_TOKEN=$(cat ~/.lf-token)`) with permissions `0600` is common on servers. The rule stays the same: the secret goes into the header and nowhere else. Avoid `curl -v` and `set -x` while debugging; both print headers.

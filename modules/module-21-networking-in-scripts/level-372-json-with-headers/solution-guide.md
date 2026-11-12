# Walkthrough: JSON with Headers

## The plan
Check the inputs, assemble one line of JSON, and POST it with a `Content-Type: application/json` header. Without the header curl labels the body as a web form and the picky API refuses it.

## Steps
1. Argument count first. Then validate the amount with a regular expression and reject double quotes in the name. We assemble JSON by string pasting, so unsafe input would produce broken JSON (or let a caller inject extra fields).
   ```bash
   [[ $amount =~ ^[0-9]+(\.[0-9]+)?$ ]] || { echo "amount must be a number" >&2; exit 2; }
   [[ $customer == *'"'* ]] && { echo "customer must not contain double quotes" >&2; exit 2; }
   ```
2. Build the body. Strings get quotes, numbers do not:
   ```bash
   json="{\"customer\":\"$customer\",\"amount\":$amount}"
   ```
3. Send it. `-H` adds the header, `-d` the body. Quote `"$json"`, because the customer name may contain a space:
   ```bash
   reply=$(curl -s -H 'Content-Type: application/json' -d "$json" \
     https://billing.lanternfish.example/api/v1/invoices)
   ```
4. Print `reply: ...`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh CUSTOMER AMOUNT" >&2
  exit 2
fi
customer=$1
amount=$2

if [[ ! $amount =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "amount must be a number" >&2
  exit 2
fi
if [[ $customer == *'"'* ]]; then
  echo "customer must not contain double quotes" >&2
  exit 2
fi

json="{\"customer\":\"$customer\",\"amount\":$amount}"
reply=$(curl -s -H 'Content-Type: application/json' -d "$json" \
  https://billing.lanternfish.example/api/v1/invoices)

printf 'reply: %s\n' "$reply"
```

## Try it by hand
```
./solution.sh "Tidewater Books" 120
cat .calls.log     # method, headers and body the server saw
```

## Alternative
A here-document or `printf '{"customer":"%s","amount":%s}'` builds the JSON just as well; `printf` keeps the template readable when there are many fields. A real JSON tool (jq) would escape values for you, but it is not always installed.

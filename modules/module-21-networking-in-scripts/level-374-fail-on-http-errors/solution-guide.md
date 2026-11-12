# Walkthrough: Fail on HTTP Errors

## The plan
Make curl report HTTP errors through its exit status, capture that status safely, and translate it into the two messages and exit codes the objective asks for.

## Steps
1. Usage check, as always.
2. Add `--fail` to the request. Now a 404 or 500 makes curl exit 22 and print nothing on stdout. `-sS` keeps the progress meter away but still lets curl explain itself on stderr.
3. Capture the exit status. Under `set -e` a bare failing command ends the script, so use the `|| rc=$?` idiom: the right-hand side only runs when curl failed, and it saves the status:
   ```bash
   rc=0
   plan=$(curl -sS --fail "$url") || rc=$?
   ```
4. Branch with `case $rc in`. Zero prints the plan, 22 is "the server said no" (exit 3) and anything else is a transport problem (exit 4), for which we include curl's own number in the message.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER_ID" >&2
  exit 2
fi
id=$1

rc=0
plan=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id/plan") || rc=$?

case $rc in
  0)  printf 'plan: %s\n' "$plan" ;;
  22) echo "plan lookup failed: the API refused the request" >&2; exit 3 ;;
  *)  echo "plan lookup failed: network error (curl exit $rc)" >&2; exit 4 ;;
esac
```

## Try it by hand
```
./solution.sh c-204
./solution.sh c-777 ; echo "exit=$?"
FAKE_NET=refused ./solution.sh c-204 ; echo "exit=$?"
```
Remove `--fail` and rerun `c-777`: the error text is printed as if it were a plan.

## Alternative
`-w '%{http_code}'` (previous levels) gives you the exact code, which you need when 404 and 500 must be handled differently. `--fail` is shorter when "any error is an error" is all you need.

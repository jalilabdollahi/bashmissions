# Walkthrough: Fetch a Page

## The plan
Build the URL from the argument, let `curl` fetch it, keep what it printed in a variable, and shape the output. The only twist is the failure path: when `curl` cannot reach the server it stops with a non-zero status, and your script should translate that into a message people understand.

## Steps
1. Guard the arguments:
   ```bash
   if [[ $# -ne 1 ]]; then
     echo "usage: solution.sh NAME" >&2
     exit 2
   fi
   ```
2. Fetch quietly. `-s` turns off the progress meter that curl draws on stderr when its output is not a terminal:
   ```bash
   text=$(curl -s "https://status.lanternfish.example/components/$name.txt")
   ```
3. Under `set -e` a failing command substitution would end the script silently, so wrap it in `if !` and print your own message:
   ```bash
   if ! text=$(curl -s "$url"); then
     echo "status page unreachable" >&2
     exit 1
   fi
   ```
4. Print with `printf`, using `${text:-no data}` so an empty page still produces a sensible line.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1

if ! text=$(curl -s "https://status.lanternfish.example/components/$name.txt"); then
  echo "status page unreachable" >&2
  exit 1
fi

printf '%s: %s\n' "$name" "${text:-no data}"
```

## Try it by hand
```
./solution.sh web
./solution.sh mail
FAKE_NET=down ./solution.sh web ; echo "exit=$?"
```
(The workspace has a pretend `curl`; nothing leaves your machine.)

## Alternative
You could send curl's output straight to the terminal (`curl -s URL`) and skip the variable. That works for a one-liner, but then you cannot add the `NAME:` prefix or the "no data" fallback, and you cannot tell whether the output was empty.

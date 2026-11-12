# Walkthrough: Ask Until Valid

## The plan
Ask, read, judge. If the answer passes, report it and finish. If it fails, say why and go around again. If the input dries up, give up with an error.

## Step by step
1. Start an open-ended loop: `while true; do`. It has no natural end, so you will leave it explicitly.
2. Print the prompt to stderr with `printf 'port> ' >&2`. Using stderr keeps stdout clean for the real result, so another script can capture `port=8080` without the prompt mixed in.
3. Read the line: `read -r port`. `read` returns a non-zero status when the input has ended, so wrap it: `if ! read -r port; then ... exit 1; fi`. Without this, a closed input would make the loop repeat forever.
4. Validate in two steps joined by `&&`: `[[ $port =~ ^[0-9]+$ ]]` makes sure it is digits only, and `(( port >= 1 && port <= 65535 ))` checks the range. The order matters: comparing the text "eighty" as a number would be an error, and `&&` skips the second test when the first fails.
5. On success print `port=$port` and `break`. Otherwise print the complaint to stderr and the loop starts again.

## Complete solution

```bash
#!/usr/bin/env bash
while true; do
  printf 'port> ' >&2
  if ! read -r port; then
    echo "no valid port given" >&2
    exit 1
  fi
  if [[ $port =~ ^[0-9]+$ ]] && (( port >= 1 && port <= 65535 )); then
    echo "port=$port"
    break
  fi
  echo "bad port: $port" >&2
done
```

## Trying it by hand
Run `bash solution.sh`, type nonsense, then `8080`. Then run `printf 'x\n' | bash solution.sh; echo $?` to see the EOF path end with status 1.

## An alternative
`until valid` with a flag variable, or a helper function that returns success only for good ports (Module 6), reads nicely too. `while true` with `break` keeps the whole story in one place for now.

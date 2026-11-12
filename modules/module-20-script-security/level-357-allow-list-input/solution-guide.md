# Walkthrough: Allow-List Input

## The plan
Replace "reject what looks bad" with "accept only what is known good". The set of
good names is small and lives in `fixtures/allowed-services.txt`, so the script's
only question is: is `$service` one of those lines?

## Why block-lists lose
Ollie blocked `;` and `&`. The attacker uses `$(...)`, a backtick, a newline, a
leading dash, or a Unicode lookalike, and the list of bad things never ends. An
allow-list has no such problem: a value is either on the list or it is out.

## Steps
1. Keep the usage check.
2. Look the value up:
   ```bash
   grep -Fxq -- "$service" fixtures/allowed-services.txt
   ```
   - `-F` fixed string, so `.*` is the three characters `.*`, not "anything".
   - `-x` whole line, so `we` does not match `web`.
   - `-q` no output, just an exit status.
   - `--` means the next word is data even if it starts with `-`.
3. If the lookup fails, print `denied: NAME` to stderr and exit 1 before anything
   is written.
4. Otherwise append and report.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SERVICE" >&2
  exit 2
fi
service=$1
if ! grep -Fxq -- "$service" fixtures/allowed-services.txt; then
  printf 'denied: %s\n' "$service" >&2
  exit 1
fi
printf '%s\n' "$service" >> queue.txt
printf 'queued: %s\n' "$service"
```

## Try it
```
./solution.sh db
./solution.sh 'web$(id)'
cat queue.txt
```

## Alternative
A `case` statement (`case $service in web|db|cache|mail-relay) ... esac`) is a
fine allow-list when the names are fixed in the script. The file version is
better when other people maintain the list, because nobody has to edit code.

# Walkthrough: Refuse to Run as Root

## The plan
At the top of the script, find out the numeric user id. If it is 0, refuse. Only
after that do the actual rotation.

## Why refuse at all?
Root bypasses permission checks, so a typo or a hostile file name does maximum
damage, and every file the script creates ends up owned by root, which then
breaks the services that should have written to it. A script that does not need
root gains nothing from it. Refusing early is cheaper than debugging ownership
later.

## Steps
1. `uid=$(id -u)` stores the number. In this practice level `id` is a stand-in
   that reads the test's `FAKE_UID`, which is why `$EUID` is not accepted here.
2. Guard:
   ```bash
   if (( uid == 0 )); then
     echo "refusing to run as root: use a normal account" >&2
     exit 1
   fi
   ```
   The message goes to stderr and the exit status is non-zero, so callers and
   cron both notice.
3. Rotate: `mv logs/app.log logs/app.log.1` replaces the old backup, and
   `: > logs/app.log` creates the empty replacement.
4. Report with `printf 'rotated as uid %d\n' "$uid"`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
uid=$(id -u)
if (( uid == 0 )); then
  echo "refusing to run as root: use a normal account" >&2
  exit 1
fi
mv logs/app.log logs/app.log.1
: > logs/app.log
printf 'rotated as uid %d\n' "$uid"
```

## Try it
```
FAKE_UID=0 ./solution.sh
FAKE_UID=1000 ./solution.sh
```
(Create `logs/app.log` first with `mkdir -p logs; echo hi > logs/app.log`.)

## Alternative
In a real script Bash already knows the answer in `$EUID`, with no process to
start: `if (( EUID == 0 ))`. We use `id -u` here because `EUID` is read-only
and cannot be faked for a test.

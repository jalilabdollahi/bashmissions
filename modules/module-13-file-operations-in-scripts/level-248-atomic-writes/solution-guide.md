# Walkthrough: Atomic Writes

## The plan

Never touch the live file while you work. Build the new version next to it,
check it, and then swap it in with a single rename.

## Why `>` is dangerous here

`cat new > config/app.conf` first *truncates* the file and then fills it as
data arrives. During that time (milliseconds, or minutes for a big file)
any reader sees an empty or partial file. A crash in the middle leaves it
broken for good.

## Step by step

Prepare a temporary file **in the same folder**:

```bash
mkdir -p config
tmp=$(mktemp config/.app.conf.XXXXXX)
cat > "$tmp"
```

The same-folder rule matters: `mv` between two places on the same disk is a
rename, one indivisible operation. Across disks `mv` silently becomes
"copy, then delete", which is not atomic at all. The leading dot hides the
temp file from simple `ls` and wildcard scans, and the `XXXXXX` become random
characters.

Validate before replacing. On failure remove the temp file and leave the
old config alone:

```bash
if ! grep -Eq '^port=[0-9]+$' "$tmp"; then
  rm -f "$tmp"
  echo "invalid config: no port= line, keeping the old file" >&2
  exit 1
fi
```

`mktemp` creates files private to you (mode 600). A web server running as
someone else could not read the result, so set the mode the real file should
have:

```bash
chmod 644 "$tmp"
mv "$tmp" config/app.conf
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

mkdir -p config
tmp=$(mktemp config/.app.conf.XXXXXX)
cat > "$tmp"

if ! grep -Eq '^port=[0-9]+$' "$tmp"; then
  rm -f "$tmp"
  echo "invalid config: no port= line, keeping the old file" >&2
  exit 1
fi

chmod 644 "$tmp"
mv "$tmp" config/app.conf

lines=$(( $(wc -l < config/app.conf) ))
echo "installed config/app.conf ($lines lines)"
```

## Try it by hand

```bash
printf 'port=8080\nworkers=4\n' | ./solution.sh
printf 'workers=2\n' | ./solution.sh ; echo "exit $?"
cat config/app.conf
ls -A config
```

## An alternative

`cat new > app.conf` is simpler and fine for a file nobody reads while you
write. For anything a running service reads, such as configs, indexes
and status files, temp-then-rename is the professional habit. A trap on
EXIT could replace the manual `rm -f` and also cover Ctrl-C.

# Walkthrough: Download and Verify

## The plan
Fetch into a temporary file, fetch the published fingerprint, compare, and only then give the file its real name. Everything that goes wrong on the way produces a specific message and leaves the directory clean.

## Steps
1. Usage check. Then create two temporary files and a trap that deletes them on exit:
   ```bash
   tmp_file=$(mktemp)
   tmp_sum=$(mktemp)
   trap 'rm -f "$tmp_file" "$tmp_sum"' EXIT
   ```
2. Download the release with `curl -sS --fail -o "$tmp_file" URL`. Without `--fail`, a missing release would save the text of a 404 page as your "download". Wrap in `if !` and report `download failed`.
3. Download `NAME.cksum` the same way; a failure here means nobody published a fingerprint, which is a different problem, so it gets its own message.
4. Compute and compare:
   ```bash
   actual=$(cksum < "$tmp_file")
   expected=$(cut -d' ' -f1,2 "$tmp_sum")
   ```
   Redirecting the file into cksum drops the name from its output, leaving `CRC SIZE`. Comparing the size as well catches truncated downloads cheaply.
5. If they differ, report and exit 1. If they match, `mv` the temporary file to `NAME` and print `verified: NAME`. After the move the trap's `rm -f` has nothing to remove for that path.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1
base=https://downloads.lanternfish.example/releases

tmp_file=$(mktemp)
tmp_sum=$(mktemp)
trap 'rm -f "$tmp_file" "$tmp_sum"' EXIT

if ! curl -sS --fail -o "$tmp_file" "$base/$name" 2>/dev/null; then
  echo "download failed: $name" >&2
  exit 1
fi
if ! curl -sS --fail -o "$tmp_sum" "$base/$name.cksum" 2>/dev/null; then
  echo "no checksum published for $name" >&2
  exit 1
fi

actual=$(cksum < "$tmp_file")
expected=$(cut -d' ' -f1,2 "$tmp_sum")
if [[ $actual != "$expected" ]]; then
  echo "checksum mismatch for $name" >&2
  exit 1
fi

mv "$tmp_file" "$name"
echo "verified: $name"
```

## Try it by hand
```
./solution.sh lfagent-2.4.tar && ls
./solution.sh lfagent-2.3.tar; echo "exit=$?"; ls
```

## Alternative
Downloading straight to `NAME` and deleting it on mismatch is shorter, but a crash between the two steps leaves a corrupt file under the real name, where another script may pick it up. Temp file plus `mv` (atomic on the same filesystem) never exposes a half-checked file.

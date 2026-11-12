# Walkthrough: Reject Empty Input

## The plan
Get the line into `code` in a way that cannot crash the script, test whether it is
empty, and either refuse or accept.

## Building it
Start with the read. When stdin has no data at all, `read` returns status 1. With
`set -e` active, that failure would end the script immediately and silently, so
your friendly error would never appear. The idiom `|| true` handles it: if `read`
fails, run `true` (which always succeeds) instead.

```bash
code=""
read -r code || true
```

Setting `code=""` first guarantees the variable exists even if `read` set nothing,
which matters under `set -u`.

The check is the `-z` operator, "zero length", used with the same guard shape as
before:

```bash
[[ -z $code ]] && { echo "error: customer code is empty" >&2; exit 1; }
```

Both an Enter-only line and an empty input leave `code` empty, so one check
covers both. (A line of only spaces is also trimmed to empty by `read`, so it is
refused too; use `IFS= read -r` if you ever need to keep surrounding spaces.)

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
code=""
read -r code || true
[[ -z $code ]] && { echo "error: customer code is empty" >&2; exit 1; }
echo "code accepted: $code"
```

## Try it by hand
```bash
echo HB-042 | ./solution.sh
echo "" | ./solution.sh; echo "status=$?"
./solution.sh < /dev/null; echo "status=$?"
```

## Alternative
`[[ $code == "" ]]` and `[[ ${#code} -eq 0 ]]` are equivalent but longer. `-z` is
the idiom people recognise, and its opposite `-n` ("not empty") is just as handy.

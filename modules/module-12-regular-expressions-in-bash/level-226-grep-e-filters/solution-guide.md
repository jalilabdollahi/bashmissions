# Walkthrough: grep -E Filters

## The plan
Check the argument, then let `grep -E` do the whole filtering in one command.

## The pattern
The status code is a space-delimited field: `... HTTP/1.1" 403 512`. Writing the
spaces into the pattern is what separates a real status from lookalikes:

```
' (401|403|429) '
```

- `/v429/status` has no space before the digits, so it does not match.
- `... 200 4011` has `4011`: a space, `401` and then `1`, not a space.
- `... 4290 5` has `429` followed by `0`.

## Why -E
Without `-E`, grep uses basic regex, where `(`, `|` and `{` are plain
characters and you have to write `\(`, `\|` (a GNU extension, not portable). `-E`
gives you the same extended syntax you used with `[[ =~ ]]`.

## The exit status
`grep` returns 0 if it selected a line, 1 if it selected none and 2 on errors.
Under `set -e` a "nothing found" would kill the script with status 1. Appending
`|| true` turns the no-match case into success while leaving the output alone.
(A genuine error such as a missing file is hidden by `|| true` too; a stricter
script would test `-r "$1"` first.)

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi
grep -E ' (401|403|429) ' "$1" || true
```

## Try it by hand
```bash
printf '1.2.3.4 "GET /" 403 5\n1.2.3.4 "GET /" 200 5\n' > t.log
./solution.sh t.log
```

## Alternative
A `while read` loop with `[[ $line =~ ' (401|403|429) ' ]]` gives the same lines,
but for a big file it is far slower than one `grep` process.

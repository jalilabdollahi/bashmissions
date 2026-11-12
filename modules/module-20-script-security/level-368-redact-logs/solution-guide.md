# Walkthrough: Redact Logs

## The plan
Run each line through three substitutions, one per secret shape. Each keeps what
is safe (the key name, the word Bearer, the user name) and replaces only the
secret.

## The three shapes
1. **key=value**: `password=hunter2`, `token=abc123&page=2`. The value runs up to
   whitespace or `&`. In sed's classes that is `[^[:space:]&]+`. The `+` demands
   at least one character, so `password=` with nothing after it stays as it is.
   The group `(password|token)` is captured and written back with `\1`, which
   also handles `api_token=` because the match simply starts at `token`.
2. **Bearer headers**: `Bearer ` followed by a run of non-space characters.
3. **URL credentials**: `scheme://user:password@host`. Capture
   `://user` as `\1`, match `:password@`, and write `\1:[REDACTED]@`. Because the
   pattern is full of slashes, use `#` as the delimiter.

## Steps
1. Start with `sed -E` and one `-e` expression per shape.
2. Add the `g` flag to each, so several secrets on one line are all handled.
3. Test with lines that have no secret at all: they must pass through unchanged.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sed -E \
  -e 's/(password|token)=[^[:space:]&]+/\1=[REDACTED]/g' \
  -e 's/Bearer [^[:space:]]+/Bearer [REDACTED]/g' \
  -e 's#(://[^:/@[:space:]]+):[^@/[:space:]]+@#\1:[REDACTED]@#g'
```

## Try it
```
printf 'u=ana password=x1 https://bob:pw@h/r\n' | ./solution.sh
```

## Alternative
One long `s///` with alternation is possible but unreadable. A loop in Bash
(`while read`) would also work, but it is slower and mangles backslashes and
whitespace unless you use `IFS= read -r`. Separate `-e` expressions are easy to
review, and review is the whole point of a security filter.

# Walkthrough: Parse Access Logs

## The plan
The combined log format mixes two separators: spaces between the simple
fields, quotes around the fields that may contain spaces. Pick the quote as the
main separator, then split three of the resulting pieces on spaces. Validate
the shape first so damaged lines are reported instead of misread.

## Step by step
1. **Cut on quotes.** `awk -F'"'`. A good line has six quote characters, so seven
   fields:
   - `$1` = `203.0.113.7 - - [04/Mar/2026:10:15:02 +0000] `
   - `$2` = `GET /login HTTP/1.1`
   - `$3` = ` 200 5123 `
   - `$4` referer, `$5` a single space, `$6` agent, `$7` empty.

2. **Split the pieces.** `split($1, h, " ")` gives five words: host, ident,
   user, `[date` and `zone]`. `split($2, r, " ")` gives method, path, protocol.
   `split($3, s, " ")` gives status and bytes. With a single space as
   separator, `split` also ignores leading and trailing blanks.

3. **Validate.** Seven fields, five/three/two words, and a status of exactly
   three digits. Anything else (a `"-"` request, a half line, text that is not a
   log line at all) goes to stderr as `bad line N` using `NR`, the physical
   line number, and `next` moves on.

4. **Print.** `substr(h[4], 2)` removes the leading `[`. A byte count of `-`
   means "no body" and is reported as 0.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F'"' '
  { sub(/\r$/, "") }
  $0 == "" { next }
  { ok = (NF == 7)
    if (ok) {
      nh = split($1, h, " "); nr = split($2, r, " "); ns = split($3, s, " ")
      ok = (nh == 5 && nr == 3 && ns == 2 && s[1] ~ /^[0-9][0-9][0-9]$/)
    }
    if (!ok) { printf "bad line %d\n", NR > "/dev/stderr"; next }
    bytes = (s[2] == "-") ? 0 : s[2]
    print h[1], substr(h[4], 2), r[1], r[2], s[1], bytes }
' "$1"
```

## Try it by hand
```bash
echo 'x "GET /a HTTP/1.1" 200 3' | awk -F'"' '{ print NF, "[" $2 "]" }'
./solution.sh access.log 2>errors.txt; cat errors.txt
```

## Alternative
A single big `sed -E` or `[[ =~ ]]` regex can pull all fields out at once, but
it is hard to read, hard to debug and gives no easy "which part was wrong".
The two-level split keeps each step small and lets you check each piece.

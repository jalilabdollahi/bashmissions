# Walkthrough: CSV to JSON

## The plan
Each row becomes one line `  {"key":value,...}`. Three decisions per value
(null, number, string) and one decision per object (comma or not). The only
dangerous part is turning arbitrary text into a valid JSON string.

## Step by step
1. **Escape by walking.** `esc()` loops over the characters with `substr`. A
   backslash becomes two, a double quote becomes backslash plus quote, anything
   else is copied. Because each input character is looked at exactly once, a
   backslash that was *added* for a quote is never escaped again. Doing it with
   two `gsub` calls in the wrong order would double the backslashes.

2. **Pick the JSON type.** `val()` returns `null` for an empty cell. If the
   cell matches the JSON number grammar `-?(0|[1-9][0-9]*)(\.[0-9]+)?`, it is
   returned untouched. Everything else is quoted and escaped. That regex is why
   `007` and `2.` are strings: JSON forbids leading zeros and a bare trailing
   dot.

3. **Keys.** On the header line store `key[i] = $i` and the count. Rows shorter
   than the header give `$i` empty, so they produce `null` automatically.

4. **Commas.** An object is held in `prev` and printed only when the next one
   arrives, with a comma. In `END` the last one goes out without a comma,
   followed by `]`. With no rows at all, `count` is 0 and `[]` is printed.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, '
  function esc(s,  out, i, c) {
    out = ""
    for (i = 1; i <= length(s); i++) {
      c = substr(s, i, 1)
      if (c == "\\") out = out "\\\\"
      else if (c == "\"") out = out "\\\""
      else out = out c
    }
    return out
  }
  function val(s) {
    if (s == "") return "null"
    if (s ~ /^-?(0|[1-9][0-9]*)(\.[0-9]+)?$/) return s
    return "\"" esc(s) "\""
  }
  { sub(/\r$/, "") }
  $0 == "" { next }
  NR == 1 { for (i = 1; i <= NF; i++) key[i] = $i; nkeys = NF; next }
  { obj = "  {"
    for (i = 1; i <= nkeys; i++) obj = obj (i > 1 ? "," : "") "\"" esc(key[i]) "\":" val($i)
    obj = obj "}"
    if (count == 0) print "["; else print prev ","
    prev = obj; count++ }
  END { if (count == 0) print "[]"; else { print prev; print "]" } }
' "$1"
```

## Try it by hand
```bash
./solution.sh prices.csv
./solution.sh prices.csv | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))'
```

## Alternative
`sed 's/"/\\"/g'` handles quotes in one line but not the number/null/string
decision, the commas, or the order of escaping. A real tool (`jq`) would do
this properly, and is the right choice when it is installed; the script here
shows what such a tool does for you.

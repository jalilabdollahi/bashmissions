# Walkthrough: JSON Lines to CSV

## The plan
For each line and each of four keys, find the key, work out whether its value
is a string or a bare token, extract it, and write it as a CSV cell. That
repeated "find a value" job becomes one awk function.

## Step by step
1. **Header first.** The input has no header, so a `BEGIN` block prints
   `ts,host,status,msg`. It also guarantees the header appears for an empty file.

2. **Find the key.** `index(line, "\"host\":")` returns where the text starts, or
   0. Searching for the quote-colon form means `"hostname":` cannot be mistaken
   for `"host":`. A missing key returns the empty string, which is the empty
   cell we want.

3. **Look at the first character of the value.** Cut away everything up to and
   including the colon with `substr`, drop spaces with `sub(/^ +/, "", rest)`.

4. **String value.** Walk from position 2. On a backslash, copy the *next*
   character and skip it (this undoes both `\"` and `\\`); on a plain quote
   stop; otherwise copy.

5. **Bare value.** `match(rest, /^[^,} ]*/)` measures the token (stops at a
   comma, brace or space). `null` becomes empty.

6. **CSV output.** If the value contains a comma or a quote, double every inner
   quote and wrap in quotes. Then print the four cells joined with commas.

## Complete solution
See `answer.sh`; its core is the `get()` and `csv()` functions above and the
single print rule `print csv(get($0,"ts")) "," csv(get($0,"host")) "," ...`.

## Try it by hand
```bash
echo '{"a":"x, y","b":3}' | awk '{ print index($0, "\"b\":") }'
./solution.sh events.jsonl
```

## Alternative
`sed -E 's/.*"host":"([^"]*)".*/\1/'` extracts one string value in one line,
but fails when the key is missing (it prints the whole line), cannot unescape,
and cannot handle numbers and strings in one go. For anything deeper than flat
objects, use a real parser such as `jq`.

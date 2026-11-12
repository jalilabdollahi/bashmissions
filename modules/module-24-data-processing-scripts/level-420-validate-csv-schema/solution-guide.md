# Walkthrough: Validate CSV Schema

## The plan
Validation is a different job from processing. The script reads every row,
prints what is wrong, and returns a verdict in two forms: a text summary for
humans and an exit status for the next script in the pipeline.

## Step by step
1. **One awk program, comma separated.** `awk -F, '...' "$1"`. A rule with no
   pattern, `{ sub(/\r$/, "") }`, runs first on every line and removes a
   Windows `\r`, so the later rules see clean text.

2. **Header.** `NR == 1` runs only for line 1. If `$0` is not exactly the
   expected header, print the error, set `fatal`, and `exit 1`. An `exit`
   inside a rule still runs `END`, which is why the flag exists: END must not
   add a second verdict. `next` skips the remaining rules for the header.

3. **Blank lines.** `$0 == "" { next }` drops them before they are counted.

4. **Row checks.** `rows++` counts the row, then an `if / else if` chain checks
   the field count first (a row with the wrong shape cannot be judged by
   column), then an empty id, then the priority against
   `/^(low|normal|high|urgent)$/`. Because it is a chain, each bad row yields
   one message. `NR` is the physical line number, so a skipped blank line
   still counts.

5. **Verdict.** In `END`: no input at all means `NR == 0`; bad rows mean
   `exit 1`; otherwise print the success line.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, '
  { sub(/\r$/, "") }
  NR == 1 { if ($0 != "id,opened,priority,subject") { print "error: unexpected header: " $0; fatal = 1; exit 1 }; next }
  $0 == "" { next }
  { rows++
    if (NF != 4) { printf "line %d: expected 4 fields, found %d\n", NR, NF; bad++ }
    else if ($1 == "") { printf "line %d: empty id\n", NR; bad++ }
    else if ($3 !~ /^(low|normal|high|urgent)$/) { printf "line %d: bad priority \"%s\"\n", NR, $3; bad++ } }
  END { if (fatal) exit 1
        if (NR == 0) { print "error: empty file"; exit 1 }
        if (bad > 0) { printf "invalid: %d of %d rows\n", bad, rows; exit 1 }
        printf "valid: %d rows\n", rows }
' "$1"
```

## Try it by hand
```bash
./solution.sh broken.csv; echo "exit=$?"
printf 'a,b,c\n' | awk -F, '{ print NF }'
```

## Alternative
A `while read` loop can count fields too (`IFS=, read -ra parts` and
`${#parts[@]}`), and it is fine for small files. awk is shorter, faster, and
gives you `NR` for free.

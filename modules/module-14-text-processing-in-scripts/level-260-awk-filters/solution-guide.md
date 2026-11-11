# Walkthrough: awk Filters

## The plan
We need to select lines by what they contain and print part of the ones that
qualify. In awk the selecting is a *pattern* and the printing is an *action*,
written together as `pattern { action }`.

## Step by step
1. List the three rules in terms of fields. The ticket layout is
   `id priority age owner status`, so priority is `$2`, age is `$3`, status
   is `$5`.

2. Translate each rule:
   - priority exactly P1: `$2 == "P1"`
   - older than three days: `$3 > 3`
   - still open: `$5 == "open"`

   Text goes in double quotes. For `$3 > 3` awk notices that both sides look like
   numbers and compares them as numbers, so 12 is greater than 3. (Comparing
   `12` and `3` as text would put 3 first.)

3. Join them with `&&`, awk's "and". The whole condition must be true for
   the action to run.

4. Write the action: print id, owner, age, in the order the objective
   asks for. The comma adds a space between the values.

   ```bash
   awk '$2 == "P1" && $3 > 3 && $5 == "open" { print $1, $4, $3 }' "$1"
   ```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk '$2 == "P1" && $3 > 3 && $5 == "open" { print $1, $4, $3 }' "$1"
```

## Try it by hand
```bash
printf 'a 5\nb 12\nc 2\n' | awk '$2 > 3'              # no action = print the line
printf 'a 5\nb 12\nc 2\n' | awk '$2 > 3 { print $1 }'  # a b
printf 'a x\nb y\n' | awk '$2 != "x"'                  # b y
```

## Alternative
`awk '{ if (...) print ... }'` does the same, and you will use `if` when the
logic grows. For a plain filter, the pattern form is shorter and is the idiom
other people expect.

# Walkthrough: awk Fields

## The plan
Every line has the same shape (engineer, time, free text, ticket) but not the
same width. `cut` counts delimiters and needs a fixed column number; `awk` splits
each line into fields and knows how many it found, so "the last one" is easy to
ask for.

## Step by step
1. Meet awk's model. For each input line awk stores the whole line in `$0`
   and splits it into fields `$1`, `$2`, `$3`... Unless told otherwise, the
   separator is any run of spaces or tabs, and blanks at the start and end of
   the line are ignored. That already takes care of the messy spacing.

2. `NF` is the number of fields on the current line. `$NF` is therefore the
   last field, and `$(NF-1)` the one before it. The `$` is awk's "field
   number" operator, so `$NF` means "the field numbered NF".

3. A program is `pattern { action }`. With no pattern, the action runs for every
   line. We print two fields:

   ```bash
   awk '{ print $NF, $1 }' "$1"
   ```

   The comma puts the output field separator (a single space by default)
   between them. Without the comma, `print $NF $1` would print `T-1042noor`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk '{ print $NF, $1 }' "$1"
```

## Try it by hand
```bash
echo "a b c d" | awk '{ print NF }'          # 4
echo "a b c d" | awk '{ print $NF }'         # d
echo "a b c d" | awk '{ print $(NF-1) }'     # c
echo "  a   b  " | awk '{ print $1 "|" $2 }' # a|b
```

## Alternative
`rev` and `cut` can fetch the last word by reversing the line, cutting field 1
and reversing it back. It works, but it is a puzzle. `$NF` says what it means.

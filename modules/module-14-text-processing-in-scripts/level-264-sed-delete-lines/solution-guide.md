# Walkthrough: sed Delete Lines

## The plan
sed is awk's older sibling: it reads a stream line by line, applies commands and
prints the result. So far you only used its substitution. The `d` command
deletes the current line, and an address in front of it chooses which lines.

## Step by step
1. An address is a regular expression between slashes. `/^;/d` would delete
   every line that starts with a semicolon. Comments in the zone can be
   indented, so allow optional blanks first with `[[:space:]]*`:

   ```bash
   sed '/^[[:space:]]*;/d'
   ```

   `^` anchors at the start of the line, and the bracket class stands for a
   space or a tab, repeated any number of times.

2. Blank lines come in two flavours: truly empty and only whitespace. One
   regex covers both: `^[[:space:]]*$`, which says "from the start, nothing but
   blanks, until the end".

3. Combine the rules. Each `-e` adds one command, and sed applies them to
   every line in order. If the first deletes the line, the second never sees
   it:

   ```bash
   sed -e '/^[[:space:]]*;/d' -e '/^[[:space:]]*$/d' "$1"
   ```

4. Check the inline comment. `www IN A 192.0.2.10 ; note` does not match
   `^[[:space:]]*;` because the first non-blank character is `w`, so it stays.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sed -e '/^[[:space:]]*;/d' -e '/^[[:space:]]*$/d' "$1"
```

## Try it by hand
```bash
printf '; c\nrec 1\n\nrec 2\n' | sed '/^;/d'
printf 'a\n\nb\n' | sed '/^$/d'
printf 'keep\nTODO x\n' | sed '/TODO/d'
```

## Alternative
`grep -v` can also drop lines: `grep -Ev '^[[:space:]]*(;|$)' "$1"`. The catch is
that `grep -v` exits with status 1 when everything is filtered out, which
trips `set -e`. sed's exit status is 0 either way, so it is the safer choice
inside a strict script.

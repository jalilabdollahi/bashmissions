# Walkthrough: Translate Characters

## The plan
Each rule is "this character becomes that character". `tr` (translate) is made
for that: it maps the characters of one list onto the characters of another,
position by position, across its whole input.

## Step by step
1. List what must change, in the order you want to pair it:
   the 26 lowercase letters, the dot, the dash.

2. List what each becomes, in the same order: the 26 capitals, an underscore,
   another underscore.

3. Write the ranges compactly. `a-z` expands to all 26 lowercase letters and
   `A-Z` to all 26 capitals, so the pairing is `a->A`, `b->B`, and so on. After
   them, `.` pairs with `_` and `-` pairs with `_`:

   ```bash
   tr 'a-z.-' 'A-Z__'
   ```

4. Why is the dash last? In a set, `x-y` means a range, so a dash in the
   middle may be read as one. At the very end it is just a dash.

5. No loop is needed. `tr` is a filter: it reads standard input until it ends
   and writes the translated text, newlines included.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
tr 'a-z.-' 'A-Z__'
```

## Try it by hand
```bash
echo "tidewater-books.api" | ./solution.sh
echo "hello" | tr 'a-z' 'n-za-m'        # ROT13 for lowercase letters
printf 'one two\n' | tr ' ' '\n'        # spaces become newlines: one word per line
```

## Alternative
In bash 4+ you can write `name=${name^^}; name=${name//[.-]/_}` for each name
in a loop. It works, but it needs a loop and two expansions. For a whole stream,
`tr` is shorter and much faster, because it never starts a new process per line.

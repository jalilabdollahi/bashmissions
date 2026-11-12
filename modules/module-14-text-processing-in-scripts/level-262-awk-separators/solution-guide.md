# Walkthrough: awk Separators

## The plan
awk has two separators and they are independent: **FS** says how to split input
lines into fields, **OFS** says what to put between the arguments of `print`
when it writes. Our job needs both changed, plus the fields in another order.

## Step by step
1. Input first. The export uses semicolons, so tell awk with `-F';'`. The
   quotes matter: an unquoted `;` ends the shell command. With a semicolon as
   separator, a customer name with spaces stays in one field, which would
   not be true with the default whitespace splitting.

2. Output. `print a, b` puts the output field separator between `a` and `b`.
   It defaults to a space. Set it with `-v OFS=','` (or `BEGIN { OFS = "," }`).

3. Pick and reorder. Field 2 is the customer, 1 the invoice, 4 the amount:

   ```bash
   awk -F';' -v OFS=',' '{ print $2, $1, $4 }' "$1"
   ```

   An empty field is just an empty string, so `INV-5;Old Mill;2026-01-01;`
   prints `Old Mill,INV-5,` with a trailing comma, as required.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F';' -v OFS=',' '{ print $2, $1, $4 }' "$1"
```

## Try it by hand
```bash
echo 'a;b;c' | awk -F';' '{ print $2 }'            # b
echo 'a;b;c' | awk -F';' -v OFS=- '{ print $1, $3 }'   # a-c
echo 'a;b;c' | awk -F';' -v OFS=, '{ $1 = $1 } 1'     # a,b,c : whole-line conversion
```

## Alternative
`tr ';' ','` converts every semicolon in one go, but it cannot drop or reorder
columns. When the job is only "change the delimiter" it is perfectly good;
the moment you want a subset of the fields, awk is the right tool. (Assigning
`$1 = $1` forces awk to rebuild the line with OFS, so the trick above does
conversion with awk too.)

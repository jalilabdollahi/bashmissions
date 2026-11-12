# Walkthrough: Reorder Columns

## The plan
Treat the header as a dictionary. Once the script knows that `email` is column 3
in *this* file, it can build each output line from names, and the layout of the
export stops mattering.

## Step by step
1. **Settings.** `awk -F, -v OFS=,` reads and writes commas. The wanted list
   arrives with `-v wanted="$2"`.

2. **Clean lines.** `sub(/\r$/, "")` removes a Windows line ending from every
   line, header included, so the last column name is `plan` and not `plan\r`.

3. **Learn the layout.** In the `NR == 1` rule, loop over the fields and store
   `pos[$i] = i`. Now `pos["plan"]` is the plan column's number.

4. **Parse the request.** `split(wanted, want, ",")` fills `want[1]`, `want[2]`
   and returns how many there are. Check each one with `want[j] in pos`.
   The `in` operator tests membership without creating an empty element, and
   the error exit happens in the header rule, before any line is printed.

5. **Rebuild each line.** A rule without a pattern runs for every line, header
   included, which is what we want: the header comes out in the new order too.
   `$(pos[want[j]])` means "the field whose number is stored under that name".
   A short row simply yields an empty field when the number is beyond `NF`.

6. **Join with commas.** Concatenating `(j > 1 ? OFS : "")` before each value
   puts separators only between columns.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
awk -F, -v OFS=, -v wanted="$2" '
  { sub(/\r$/, "") }
  NR == 1 {
    for (i = 1; i <= NF; i++) pos[$i] = i
    n = split(wanted, want, ",")
    for (j = 1; j <= n; j++)
      if (!(want[j] in pos)) { print "unknown column: " want[j] > "/dev/stderr"; exit 1 }
  }
  { out = ""
    for (j = 1; j <= n; j++) out = out (j > 1 ? OFS : "") $(pos[want[j]])
    print out }
' "$1"
```

## Try it by hand
```bash
./solution.sh customers.csv "email,name"
./solution.sh customers.csv "plan,plan,id"
```

## Alternative
`cut -d, -f3,2` also selects columns, but always in file order (it cannot
reorder), and it works only with numbers. `awk '{ print $3, $2 }'` reorders,
but again with hard-coded numbers. Looking names up in the header is what makes
the script survive a changing export.

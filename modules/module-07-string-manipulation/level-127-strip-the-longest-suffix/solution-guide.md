# Walkthrough: Strip the Longest Suffix

## The plan
Read each name, cut everything from its first dot to the end, print both names
with the arrow.

## Reading stdin
`while IFS= read -r name; do ... done` reads one line per turn. `IFS=` keeps
surrounding spaces and `-r` keeps backslashes, which is the safe default. A last
line without a newline makes `read` return failure even though `name` is filled,
so the loop condition adds `|| [[ -n $name ]]` to still process it.

## Cutting the name
The suffix we want to delete is "a dot and everything after it", starting at the
**first** dot. A pattern `.*` can match from any dot, so there are several
possible suffixes. Take `web-03.eu-west.prod.example`:

| expansion | removes | leaves |
|---|---|---|
| `${name%.*}` | `.example` | `web-03.eu-west.prod` |
| `${name%%.*}` | `.eu-west.prod.example` | `web-03` |

The greedy `%%` takes the longest suffix that matches, which begins at the first
dot.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r name || [[ -n $name ]]; do
  short=${name%%.*}
  echo "$name  =>  $short"
done
```

## Try it by hand
```bash
printf 'web-03.eu-west.prod.example\nlocalhost\n' | ./solution.sh
```

## Alternative
`echo "$name" | cut -d. -f1` gives the same short name but starts two processes
for every line, which adds up over a big inventory. The expansion also needs no
special case for names without a dot: no match means no change.

# Walkthrough: Count a Character

## The plan
There is no built-in "count of x in string", so we derive it: delete every
character that is not the one we care about, then measure what is left.

## Delete everything else
In a pattern, `[^,]` is a bracket expression with a caret: it matches **one
character that is not a comma**. Combine it with the replace-all expansion and an
empty replacement:

```bash
commas=${row//[^,]/}
```

For `INV-1001,Harbour Bakery,2024-11-03,420.00` every letter, digit, dash, dot and
space is deleted, and `commas` becomes `,,,`.

## Measure
The length expansion from the first level of this module finishes the job:

```bash
count=${#commas}
```

Two expansions cannot be nested, so the intermediate variable is the clean way.

## Report
Number the rows with a counter and compare `count` with 3:

```bash
if (( count == 3 )); then ... else ... fi
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
n=0
while IFS= read -r row || [[ -n $row ]]; do
  n=$((n + 1))
  commas=${row//[^,]/}
  count=${#commas}
  if (( count == 3 )); then
    echo "row $n: ok"
  else
    echo "row $n: bad ($count)"
  fi
done
```

## Try it by hand
```bash
printf 'a,b,c,d\na,b\n' | ./solution.sh
```

## Alternative
`tr -cd , <<< "$row" | wc -c` counts too, but spawns two processes per row and
`wc -c` pads its output on macOS. The delete-then-measure idiom works for any
character, or any set of characters: just change what is inside the brackets.

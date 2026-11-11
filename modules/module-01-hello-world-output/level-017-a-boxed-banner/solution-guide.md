# Walkthrough: A Boxed Banner

## The plan
The box has two identical borders around a padded title row. The title row is a normal printf with a width, like level 7. The new part is the border: 30 equals signs without typing 30 equals signs.

## Step by step
1. Know the repeat rule: if printf is given more values than the format consumes, it runs the format again from the start for the remaining values.
2. Take the format `'=%.0s'`. It prints an equals sign, then the value with a precision of zero, meaning nothing at all.
3. Give it thirty values. `{1..30}` is brace expansion, which Bash turns into the numbers 1 to 30 before printf runs.
4. The border therefore is `printf '=%.0s' {1..30}`, and a final `printf '\n'` ends that line.
5. The middle row: `| ` + the title in a 26-wide field + ` |`, which makes 30 columns in total.

## Complete solution

```bash
#!/usr/bin/env bash
printf '=%.0s' {1..30}; printf '\n'
printf '| %-26s |\n' "$TITLE"
printf '=%.0s' {1..30}; printf '\n'
```

## Trying it by hand
`TITLE="Monday Numbers" bash solution.sh`. Change 30 to 40 and the 26 to 36 to see the box grow.

## An alternative
`printf '%*s' 30 '' | tr ' ' '='` builds a run of spaces and swaps them for equals signs. A loop with `for` does it too. The `%.0s` trick is shortest, but the version you can read tomorrow is the one to keep.

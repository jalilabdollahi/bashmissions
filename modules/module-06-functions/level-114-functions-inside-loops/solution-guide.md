# Walkthrough: Functions Inside Loops

## The plan
The loop reads and counts; the function formats. Neither knows the other's
details, so each is simple.

## Building it
The function receives two values and decides the label. Giving `label` a default
of OK means only the two exceptions need a test:

```bash
print_row() {
  local host=$1 pct=$2 label=OK
  if (( pct >= 90 )); then
    label=CRIT
  elif (( pct >= 70 )); then
    label=WARN
  fi
  printf '%-10s %3d%%  %s\n' "$host" "$pct" "$label"
}
```

In `printf`, `%-10s` pads the host to 10 characters on the right, `%3d` right-aligns
the number in 3 places, and `%%` prints a literal percent sign.

The loop reads two words per line. Reading straight from stdin, not through a
pipe, keeps the loop in the main shell, so `rows` survives to the end:

```bash
rows=0
while read -r host pct; do
  [[ -z $host ]] && continue
  print_row "$host" "$pct"
  rows=$(( rows + 1 ))
done
echo "rows: $rows"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
print_row() {
  local host=$1 pct=$2 label=OK
  if (( pct >= 90 )); then label=CRIT
  elif (( pct >= 70 )); then label=WARN
  fi
  printf '%-10s %3d%%  %s\n' "$host" "$pct" "$label"
}
rows=0
while read -r host pct; do
  [[ -z $host ]] && continue
  print_row "$host" "$pct"
  rows=$(( rows + 1 ))
done
echo "rows: $rows"
```

## Try it by hand
```bash
printf 'dory 45\nmarlin 72\ngrouper 95\n' | ./solution.sh
```

## Alternative
Put the `if` chain right in the loop body. It runs the same, but the loop grows
with every new rule and the row layout cannot be reused (for example by a second
report). The function keeps the loop at four lines.

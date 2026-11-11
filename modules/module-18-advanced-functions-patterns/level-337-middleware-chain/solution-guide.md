# Walkthrough: Middleware Chain

## The plan

Every step has the same shape: text in, text out. That is what lets them be
chained: the result of step one is the input of step two. The chain itself is
just an array of step names, in order.

## Step by step

The steps. Each prints its result with `printf '%s'`, so no newline is added
and spaces survive:

```bash
mw_lower() { printf '%s' "${1,,}"; }
mw_mask()  { printf '%s' "${1//[0-9]/#}"; }
mw_clip()  { printf '%s' "${1:0:12}"; }
```

`mw_trim` uses a well-known pair of expansions. `${s%%[![:space:]]*}` is
the leading whitespace (everything before the first non-space), and removing
it with `#` strips the front; the mirror pair strips the back:

```bash
s=${s#"${s%%[![:space:]]*}"}
s=${s%"${s##*[![:space:]]}"}
```

`mw_squeeze` repeats `${s//  / }` (two spaces become one) while the text still
contains two spaces in a row; one pass would leave runs of three or more
only half squeezed.

Now the chain. Keep the names in an array and verify them all first, so a typo
fails before any output:

```bash
chain=("$@")
for step in "${chain[@]}"; do
  declare -F "mw_$step" > /dev/null || { echo "unknown middleware: $step" >&2; exit 2; }
done
```

Run each line through the chain. `IFS= read -r` keeps the line untouched; a plain
`read` would trim it before `mw_trim` ever saw it:

```bash
while IFS= read -r line; do
  value=$line
  for step in "${chain[@]}"; do
    value=$("mw_$step" "$value")
  done
  echo "[$value]"
done
```

## Try it by hand

```
printf '  Hello   World  \n' | ./solution.sh trim squeeze lower
printf '   abc def ghi jkl mno\n' | ./solution.sh trim clip
printf '   abc def ghi jkl mno\n' | ./solution.sh clip trim
```

The last two differ: order matters.

## Alternative

A real pipeline (`printf | sed ... | tr ...`) does the same for fixed steps.
The function chain wins when the steps are chosen at run time, and when you
want to unit-test each step on its own.

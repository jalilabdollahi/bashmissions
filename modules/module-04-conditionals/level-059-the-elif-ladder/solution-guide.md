# Walkthrough: The elif Ladder

## The plan

One input, five possible answers. We want exactly one line printed. The tool for
"first match wins" is `if ... elif ... else`: Bash tests the conditions from the
top down, runs the body of the first true one and jumps to `fi`.

## Building it

Start with the most important case and the variable:

```bash
code="$1"
if [[ $code == 200 ]]; then
  echo "healthy: nothing to do"
```

Every further known code is another rung. Note that `elif` also needs its own
`then`:

```bash
elif [[ $code == 301 ]]; then
  echo "moved: check the redirect"
elif [[ $code == 404 ]]; then
  echo "not found: tell Noor"
elif [[ $code == 503 ]]; then
  echo "backend down: page Mara"
```

The last rung has no test at all. `else` means "none of the above" and is the
right place for the unexpected-code message, which can reuse `$code`:

```bash
else
  echo "unexpected status $code: ask Theo"
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

code="$1"

if [[ $code == 200 ]]; then
  echo "healthy: nothing to do"
elif [[ $code == 301 ]]; then
  echo "moved: check the redirect"
elif [[ $code == 404 ]]; then
  echo "not found: tell Noor"
elif [[ $code == 503 ]]; then
  echo "backend down: page Mara"
else
  echo "unexpected status $code: ask Theo"
fi
```

## Try it by hand

```bash
for c in 200 404 418; do ./solution.sh "$c"; done
```

## An alternative

A stack of separate `if` blocks would also print the right line for each code,
but nothing would stop two of them firing, and a final "else" would be
impossible. Level 73 introduces `case`, which is tidier for a long list of fixed values.

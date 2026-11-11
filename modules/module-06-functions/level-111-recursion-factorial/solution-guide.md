# Walkthrough: Recursion: Factorial

## The plan
Define the answer in terms of a smaller answer. `n! = n * (n-1)!`, with
`0! = 1! = 1`. The second part is the base case, the first is the recursive step.

## Building it
Base case first. For 0 or 1 the answer is 1, and we are done:

```bash
if (( n <= 1 )); then
  echo 1
  return
fi
```

Recursive step: ask the same function about `n-1`, capture its printed answer,
multiply:

```bash
local smaller
smaller=$(factorial $(( n - 1 )))
echo $(( n * smaller ))
```

Tracing `factorial 3`: it calls `factorial 2`, which calls `factorial 1`. That one
prints 1; the 2-level multiplies and prints 2; the 3-level prints 6. Each call has
its own `local n`, which is why `local` matters in a recursive function: without
it the calls would trample each other's `n`.

The argument check keeps junk out (`five` would be treated as 0 by arithmetic).

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
factorial() {
  local n=$1
  if (( n <= 1 )); then echo 1; return; fi
  local smaller
  smaller=$(factorial $(( n - 1 )))
  echo $(( n * smaller ))
}
if [[ ${1:-} =~ ^[0-9]+$ ]]; then
  factorial "$1"
else
  echo "usage: solution.sh N" >&2
  exit 1
fi
```

## Try it by hand
```bash
./solution.sh 5
./solution.sh 20
```

## Alternative
A plain loop (`for ((i=2; i<=n; i++)); do r=$((r*i)); done`) is faster and uses no
processes. Recursion is not the best tool for factorials in Bash; it is the best
way to *learn* the idea you need for the next level.

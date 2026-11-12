# Walkthrough: Local Variables

## The plan
The arithmetic is easy; the lesson is where the variables live. We compute in a
function with `local` working names and then check from outside that nothing leaked.

## Building it
Declare the scratch names at the top of the function:

```bash
local subtotal tax total
```

Then compute. `$(( ))` does integer arithmetic, so dividing by 10 rounds down:

```bash
subtotal=$(( $1 * $2 ))
tax=$(( subtotal / 10 ))
total=$(( subtotal + tax ))
echo "line total: $total"
```

The caller runs it as a plain command. This matters: a plain call runs in the
main shell, so any variable it forgot to make `local` would stay behind.

```bash
line_total "$1" "$2"
```

To prove the cleanup, print `${total:-none}` outside. `:-none` means "use `none`
if the variable is unset or empty". Try deleting the `local` line and running
again: the last line then shows the leaked total instead of `none`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
line_total() {
  local subtotal tax total
  subtotal=$(( $1 * $2 ))
  tax=$(( subtotal / 10 ))
  total=$(( subtotal + tax ))
  echo "line total: $total"
}
line_total "$1" "$2"
echo "leaked total: ${total:-none}"
```

## Try it by hand
```bash
./solution.sh 3 50
```

## Alternative
Compute with `echo $(( $1 * $2 * 11 / 10 ))` and no variables at all. Shorter, but
you lose the readable names, and the rounding differs for some inputs. Naming the
steps is worth a `local`.

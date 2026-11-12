# Walkthrough: Number Bases

## The plan

Convert both inputs to plain numbers with the `base#digits` notation, print
those as decimal, then use `printf` to write each of them in a different base.

## The notation

| written | base | value |
|---|---|---|
| `2#1010` | 2 | 10 |
| `8#755` | 8 | 493 |
| `16#ff` | 16 | 255 |

Bash accepts bases from 2 to 64 this way, and the digits after `#` can come
from a variable, as in `16#$port_hex`.

## Building it

```bash
port=$(( 16#$port_hex ))
mode=$(( 8#$mode_oct ))
```

The inputs are now ordinary numbers, and `echo` prints them in decimal.

Going the other way is `printf`'s job. `%o` writes octal, `%x` lowercase hex,
`%X` uppercase:

```bash
printf 'port_octal=%o\n' "$port"
printf 'mode_hex=%x\n' "$mode"
```

Notice why the explicit `8#` matters for the second argument. If the
value were used as plain `$(( 0644 ))`, Bash would also read it as octal, because a
leading zero means "octal". With `8#` there is no guessing, and the 0 does no
harm. `8#08` is still an error: 8 is not an octal digit.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

port_hex="$1"
mode_oct="$2"

port=$(( 16#$port_hex ))
mode=$(( 8#$mode_oct ))

echo "port=$port"
echo "mode=$mode"
printf 'port_octal=%o\n' "$port"
printf 'mode_hex=%x\n' "$mode"
```

## Try it by hand

```bash
./solution.sh 1f90 640
printf '%d\n' 0x1f90        # printf reads 0x... too
echo $(( 2#1111 ))          # 15
```

## An alternative

`printf '%d' 0x1f90` converts a hex literal with the `0x` prefix, and
`$(( 0x1f90 ))` works too. Both need the prefix to be part of the text. When
the digits come from a variable that may not have one, `16#$var` is the more
direct approach.

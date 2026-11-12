# Walkthrough: Powers

## The plan

An IPv4 address has 32 bits. A `/24` network uses 24 of them to say which
network it is, leaving 8 bits for hosts. Each free bit can be 0 or 1, so 8 bits
give 2 x 2 x 2 x 2 x 2 x 2 x 2 x 2 = 2 to the power of 8 = 256 addresses.
Two of those are reserved, so 254 can be handed to machines.

## Building it

The exponent is `32 - prefix`. In arithmetic, `**` is the power operator:

```bash
echo $(( 2 ** 8 ))      # 256
```

Because the exponent is itself an expression, wrap it in parentheses. `**`
is stronger than `-`, so without them Bash would compute `(2 ** 32) - prefix`,
which is a huge wrong number:

```bash
addresses=$(( 2 ** (32 - prefix) ))
hosts=$(( addresses - 2 ))
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

prefix="$1"

addresses=$(( 2 ** (32 - prefix) ))
hosts=$(( addresses - 2 ))

echo "addresses=$addresses"
echo "hosts=$hosts"
```

## Try it by hand

```bash
./solution.sh 24
./solution.sh 30
echo $(( 2 ** 10 ))     # 1024, a nice number to remember
```

## An alternative

A shift does the same for powers of two: `1 << (32 - prefix)`. It is common in
low-level code, but it only works for base 2 and reads like bit-twiddling.
`**` says what you mean, works for any base, and is the better choice when the
goal is a count rather than a bit mask.

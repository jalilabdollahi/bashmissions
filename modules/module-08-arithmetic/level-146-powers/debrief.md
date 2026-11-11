# Debrief: Powers

## What you learned

`**` repeats multiplication. It is the operator for anything that doubles,
triples or otherwise grows by a constant factor: addresses in a network,
combinations of switches, kilobytes, megabytes and gigabytes.

## Under the hood

`**` has higher precedence than `*`, and unlike most operators it groups from
the right: `2 ** 3 ** 2` means `2 ** (3 ** 2)`, which is 512, not 64. Use
parentheses when you chain it. The exponent has to be a whole number; a
negative exponent is an error, because integers cannot hold 1/2.

Like everything else in Bash arithmetic, results are 64-bit. `2 ** 62` is fine,
`2 ** 63` wraps to a negative number, and `2 ** 64` is 0. There is no
overflow warning, so when exponents come from input you should sanity check
them.

## In real work

Subnet sizes, binary-prefix storage units (`1024 ** 3` bytes in a gibibyte),
exponential back-off delays (`2 ** attempt` seconds), and "how many
combinations is that password space".

## Going further

So far every number has been computed fresh. Next up: counters, the small
variables that tick up and down as a script works through its input.

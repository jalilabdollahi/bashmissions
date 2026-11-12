# Debrief: let and (( ))

## What you learned

`let` and `(( ))` are two spellings of the same feature: run an arithmetic
expression as a command. Both can assign, increment and compare. Both also
share one oddity: their exit status is the truth value of the result, where
non-zero means success (0) and zero means failure (1).

## Under the hood

Shell convention says status 0 means success. Arithmetic in C says non-zero
means true. `(( ))` bridges the two by returning 0 when the value is true
(non-zero), so that `if (( x )); then` reads naturally. The side effect
is that an expression like `(( count = 0 ))` or `let "free = 0"` "fails".
Normally nobody looks, but under `set -e` the script exits at that very line.

The other difference is syntax. `let` receives ordinary words, so it needs
quoting: `let x=2*3` works only because there are no spaces, and `let x=2 * 3`
runs a glob over `*`. `(( ))` is parsed by the shell itself, so spaces and
operators are safe.

## In real work

You will meet `let` in older scripts and install-time helpers. In new code use
`$(( ))` to compute a value and `(( ))` to update or to test.

## Going further

Because `(( ))` already reports true or false, it makes a very natural
condition for `if`. That is the next level.

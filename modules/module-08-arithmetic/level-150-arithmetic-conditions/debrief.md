# Debrief: Arithmetic Conditions

## What you learned

`(( ... ))` is a condition as well as a calculator. Inside an `if` it asks a
yes/no question about numbers, using the symbols from maths: `<`, `<=`, `>`,
`>=`, `==`, `!=`, and `&&` and `||` to combine them. It is the number
counterpart of `[[ ]]`, which compares text and files.

## Under the hood

As you saw in the previous level, `(( expr ))` exits with status 0 when the
expression is non-zero ("true" in C terms) and 1 when it is zero. `if` only cares
about that status, so `if (( x > 5 ))` just works. The comparison itself
evaluates to 1 or 0.

The other trick of this level is avoiding division. Integer division
truncates, so the fractional part is lost. Multiplying both sides of the
inequality keeps everything exact. That is why the threshold tests look
unusual and are still the better version.

One more thing: inside `(( ))`, `==` compares numbers. `(( 010 == 8 ))` is true
because a leading zero means octal (you will see that trap again in the
bases level). For strings, stay with `[[ ]]`.

## In real work

Thresholds for disk, memory and queue length, retry limits, "is this the 10th
attempt yet?", and range checks on arguments.

## Going further

Everything so far was whole numbers. Gus is about to ask for a bill in
dollars and cents, and that is when integer arithmetic runs out and a
different tool steps in.

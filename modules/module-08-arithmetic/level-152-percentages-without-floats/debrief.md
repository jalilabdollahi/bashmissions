# Debrief: Percentages Without Floats

## What you learned

Fixed-point arithmetic: pick a unit small enough that everything is a whole
number (tenths, cents, milliseconds), compute in that unit, and add the decimal
point only when printing. Almost every financial system does it this way,
because integers never drift.

## Under the hood

Integer division truncates, so `used / total * 100` throws away the fraction
at the first step and multiplies the damage afterwards. Multiplying first
keeps the information, at the price of larger intermediate numbers. With
64-bit integers there is a lot of room, but it is not unlimited: `used * 1000`
only overflows for values above about 9 * 10^15 (petabytes counted in bytes
would come close).

The split `n / 10` and `n % 10` is the same pair of operators as the uptime
level. The only thing new is the idea that the point is not part of the number
at all; it is a presentation detail.

Because the result is truncated, 99.99% displays as 99.9%. That is the right
behaviour for a capacity figure (never promise more room than you have).

## In real work

Money in cents, durations in milliseconds, disk use shown on a status page,
and any place where an external tool is unavailable.

## Going further

Digits come in more than one flavour. Next, hexadecimal and octal numbers,
the notations for ports, permissions and colours.

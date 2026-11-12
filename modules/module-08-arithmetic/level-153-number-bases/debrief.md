# Debrief: Number Bases

## What you learned

The value of a number and the way it is written are two different things.
Inside `$(( ))` you can read any base with `base#digits`, and `printf`
(`%x`, `%o`, `%d`) writes a value in the base you want. Between them you can
translate anything.

## Under the hood

Internally Bash holds one 64-bit integer, and it does not care how you wrote
it. What changes is only the parsing on input and the formatting on output.
Three shortcuts are built in: `0x` for hexadecimal, a leading `0` for octal,
and `base#` for anything else.

That leading-zero rule is the trap of this level: `$(( 010 ))` is 8, and
`$(( 08 ))` or `$(( 09 ))` is an error ("value too great for base"). Dates and
times are the usual victims: a loop that reads minutes "07", "08" works until
the eighth. When digits come from text, force the base: `$(( 10#$minutes ))`
reads "08" as plain decimal 8.

## In real work

Ports and addresses (hex), file permissions (octal, as in `chmod 640`), colour
values, bit masks and network tools that print everything in hex.

## Going further

Numbers can be predictable, or they can be random. Next, you will ask Bash for
a random number and force it into a range.

# Debrief: Counting from the End

Offsets can run in both directions. A positive offset counts from the start, a
negative one from the end, and `${key: -4}` reads naturally as "the last four".
Many real strings are anchored at the end rather than the start: file
extensions, the last digits of a card number, a checksum appended to a code,
the final octet of an address.

The syntax has one famous trap. In `${var:-4}` the sequence `:-` already means
"if empty, use this default", so Bash cannot also use it for negative offsets.
The space (or parentheses) separates the two readings. This is the kind of detail
that explains why Bash scripts look picky: the shell has few characters to spend
and every combination is already taken.

Also note the guard. When the offset reaches before the start, Bash does not
complain; it returns an empty string. Silent empties are how bugs hide, so a
cheap length check before slicing is a good habit, and printing errors to stderr
keeps masked output clean for whatever reads it.

Going further: slicing needs you to know *where* to cut. The next levels cut by
pattern instead: "remove everything up to the first slash".

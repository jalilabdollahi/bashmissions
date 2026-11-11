# Debrief: Strip the Longest Suffix

Now all four trimming operators are in your hands: `#` and `##` trim the front,
`%` and `%%` trim the back, and the doubled form is always the greedy one.
The rule for choosing is simple once you ask: "if my pattern could match more than
one way, which way do I want?" For the *last* extension you wanted the shortest
tail. For the *first* label of a hostname you want the longest tail, because the
dot you care about is the leftmost one.

A good test of understanding: `${name%%.*}` and `${name#*.}` are complementary on
a name with a dot. One gives the part before the first dot, the other the part
after it. Between the four operators you can take apart most structured strings:
paths, versions (`1.4.2`), `user@host`, `host:port`.

Notice also the stdin loop. Reading lines safely with `IFS= read -r` is a pattern
you will reuse in every text-processing script, and the `|| [[ -n $name ]]` guard
is the small detail that stops the last line being silently dropped when a file
lacks a final newline.

Going further: so far the pattern had to sit at an end. The next levels replace a
match anywhere in the string.

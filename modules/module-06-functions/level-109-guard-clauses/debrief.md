# Debrief: Guard Clauses

A guard clause answers "should I even be here?" at the top of a function and
leaves immediately if not. The opposite style nests the real work inside
`if valid; then if also_valid; then ...`, and the actual job ends up three levels
deep with its `else` branches far from the tests they belong to.

The mental model is a bouncer at the door: each check turns away one kind of bad
input with a precise message and a distinct status code. By the time the code
reaches the bottom, it can assume everything is valid. That assumption is what
makes the rest of the function short and boring, which is exactly what you want.

Two details to remember. Errors go to stderr (`>&2`) so they never pollute
the data a caller captures with `$( )` (as you saw in level 105). And distinct
return codes let callers react differently: `2` for "you called me wrong", `4` for
"your value is out of range".

Order your guards from the cheapest and most basic (is it there?) to the most
specific (is it in range?), and validate type before value, since arithmetic on
text is an error in itself.

Going further: bigger scripts keep their functions in a separate file so many
scripts can share them. That is the next level: `source`.

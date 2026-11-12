# Debrief: Parse CSV Rows

The mental model: **`read` is a splitter with a destination.** It takes one
line, cuts it at every character found in `IFS`, and assigns the pieces to the
variables you name, left to right. Normally `IFS` holds blanks and tabs; setting
it to a comma turns the same machinery into a CSV reader, and putting the
assignment directly before `read` keeps the change local to that one command.

Two rules explain most of the surprises. First, if there are more pieces than
variables, the **last variable receives the rest of the line**, commas
included. That is a feature when a free-text column comes last, and a trap when
you forget it. Second, `read` reports failure at end of input, but a final
line with no newline still arrives in the variables; real exports often end
that way, so the loop condition must allow for it.

Text from other systems carries invisible baggage. A `\r` at the end of the last
column is the classic one: it prints as nothing yet makes `==` fail. Cleaning
input at the boundary, once, keeps the rest of the script simple.

This simple split has one hard limit: it does not understand quoted fields.
`"Gull, Anchor"` would be cut in two. Plain exports like these are fine; when
quoting appears you need a real parser.

Going further: before trusting a file, check that every row has the number of
columns you expect. The next level validates a CSV's schema and reports bad
rows by line number.

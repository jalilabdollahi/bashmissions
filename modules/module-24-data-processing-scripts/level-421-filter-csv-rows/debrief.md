# Debrief: Filter Rows

The mental model: **a filter is a predicate applied to a stream of rows.** You
describe what a keeper looks like, and everything else falls away. awk's
`pattern { action }` form is exactly that. Patterns are boolean expressions,
and the default action is "print the line", so a one-line condition is a
complete program.

The subtle part is types. awk has no declared types; it decides by looking at
the value. Text read from a file is a string that "looks numeric" only if it
really is a number, and comparing a string to a number falls back to text
comparison. That is how `9` ends up bigger than `10`. Adding zero (`$3 + 0`)
is the idiom to force a number. Equally important is guarding against cells
that are not numbers at all: `n/a` plus zero is `0`, which would quietly pass a
`>= 0` filter. Check the shape with a regex first, then compare.

Values come from the shell with `-v`. That keeps data and program separate,
the same principle as using parameters instead of string-built SQL.

In real work this is the first step of nearly every report: select the rows,
then sum, group or format them. Capacity planning, billing runs and security
reviews all start with "only rows where ...".

Going further: filtering keeps whole rows. The next level keeps all the rows
but changes the shape, picking and reordering columns by name.

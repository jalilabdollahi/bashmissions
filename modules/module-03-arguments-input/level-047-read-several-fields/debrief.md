# Debrief: Read Several Fields

When `read` gets more than one variable name it performs *word splitting* on the
line using `IFS`, the same variable you used as glue in level 41, now as the
knife. That is why runs of spaces collapse and why the last variable swallows
the remainder: `read` stops cutting when it has run out of names.

This gives a tidy mental model of a record: a line is a row, `read` with N names
turns it into N columns, and the final column is the "everything else" column.
That is why free-text fields (a description, a role, a message) are always placed
last in line-oriented formats.

Short lines are not errors: the missing fields are empty, so scripts that need
all of them must check for emptiness, which is exactly what level 51 teaches.

Real uses: parsing the output of other tools, for example `ls -l`, `df` or
`/etc/passwd`-style files with `IFS=:`, and handling space-separated logs.

Going further: what if you do not know in advance how many fields there are? The
next level stores the fields in an array.

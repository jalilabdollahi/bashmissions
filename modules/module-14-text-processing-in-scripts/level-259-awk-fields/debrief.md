# Debrief: awk Fields

awk is the tool you reach for when `cut` is not enough. Where `cut` splits at a
single character and counts delimiters, awk thinks in records and fields: each
line is a record, each whitespace-separated word is a field, and the program
you give it is run against every record. It also numbers the fields from the
left (`$1`) and tells you how many there are (`NF`), so you can address columns
from the right as well.

The default separator is the important difference. `cut -d' '` treats two
spaces as an empty field between them; awk treats any run of blanks as one
separator and ignores blanks at the edges. For human-formatted text such as
`ps` or `ls -l` output, awk's behaviour is what you want.

Under the hood awk splits the line only when you ask for a field, and it
reuses the same rule every time. Assigning to a field or `$0` makes it rebuild
the line, a trick the later separator level relies on.

Going further: so far the action has run on every line. Next level adds a
condition in front of it, so awk selects the lines it acts on.

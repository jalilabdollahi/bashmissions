# Debrief: Don't Parse ls

`ls` is a program that formats a directory for a person. Its output is one long
string, and strings lose information: a newline inside a file name is
indistinguishable from the separator, a name with spaces looks like several names,
and different systems add colours, quotes or escapes when stdout is a terminal. Any
script that reads that string is guessing.

A glob is different. The shell reads the directory itself and produces a list of
words, one per entry, with each name delivered intact as a separate argument. Loops
over `"$dir"/*` therefore work for every legal file name. Because globbing happens
after variables are expanded, you must quote the variable part and leave the `*`
bare. A wildcard that matches nothing is left as literal text, so we test with
`[ -f ]` (this also removes directories). Parameter expansion trims each result:
`${f##*/}` for the file name, `${f%/*}` for its folder.

Where else does this idea show up? Anywhere text pretends to be data: parsing `ps`
output instead of asking the system, scraping `df`, or splitting a CSV with `cut` when
fields contain commas. The lasting habit is to ask where the structured data lives,
and to use the shell feature that hands it over whole.

Going further: when you need recursion or all hidden files, `find -print0` with a
NUL-delimited loop is the equivalent of the glob; you will meet it in later modules.

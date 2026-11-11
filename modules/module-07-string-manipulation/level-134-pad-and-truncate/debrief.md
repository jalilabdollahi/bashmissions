# Debrief: Pad and Truncate

`printf` is a string tool in disguise. In a `%s` conversion the **width** means
"fill up to at least this many columns" and the **precision** means "use at most
this many characters". Together `%-14.14s` creates a cell that is exactly 14
characters no matter what goes in. The minus flips the alignment from right (the
default) to left, which is why names look like a table and numbers usually do
not use it.

Fixed-width layout matters for anything a human or a legacy system reads
column by column: reports, line printer jobs, EDI files and bank exports, fixed
log prefixes, and terminal dashboards. The same idea works for numbers: `%05d`
zero-pads, `%8.2f` right-aligns a price with two decimals.

Note what happens with the separator. `IFS=,` is set only for the single `read`
command, so the rest of the script keeps its normal word splitting. That
"temporary variable in front of a command" form is the idiom for any command that
reads `IFS`.

One careful point: counting is by character in a UTF-8 locale but by byte under
`LC_ALL=C`, so tables with accented names can misalign. Keep to ASCII when
exactness matters.

Going further: the `read` here split the line at a delimiter without telling you
how it works. The next level makes that splitting the main subject.

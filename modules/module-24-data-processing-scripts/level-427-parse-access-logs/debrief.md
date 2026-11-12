# Debrief: Parse Access Logs

The mental model: **parse with the separator that matches the structure.** The
combined log format looks like columns, but it has two kinds of fields: plain
tokens and quoted strings that may contain spaces. Splitting on spaces gets the
quoted ones wrong; splitting on quotes isolates them. Then each isolated piece
is plain enough to split on spaces. Two cheap passes of `split` beat one
clever regex.

The second lesson is trust. A log is written by many different clients, and
some of them send garbage: nothing at all (`"-"` after a timeout), binary
junk, truncated lines when a disk fills up. Reading positions blindly gives
confident wrong output. Counting the pieces (`NF`, and the return value of
`split`) is a cheap structural test, and reporting failures by line number turns
"the script ate some lines" into something you can investigate. Skipping with a
message is usually better than stopping the whole job and better than guessing.

The format itself is worth knowing: it is the default of Apache and nginx, and
nearly every log analyser starts by parsing it. `-` means "unknown", which is why
a missing byte count is turned into 0 here.

Going further: once each request is a clean line, summarising them is easy.
The next level counts requests per status class, which is where parsing pays
off.

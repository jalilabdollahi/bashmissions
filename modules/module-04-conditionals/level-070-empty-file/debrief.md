# Debrief: Empty File?

`-s` collapses two checks into one. A report that was never produced and a
report that was produced but is blank are, for the reader, the same failure.
The test says "yes, there is data here" or "no, there is not".

## Under the hood

The operating system keeps a size in bytes for every file; `-s` asks whether it
is greater than zero. It does not read the contents, so a file full of spaces,
or a single newline, counts as "has size". When "empty" should include
"blank", count meaningful lines or search for a non-space character with `grep -q
'[^[:space:]]'`.

The line-count idiom is worth memorising too. `wc -l file` prints the name
along with the number, while `wc -l < file` prints the number alone because
`wc` sees an anonymous input. And `$(( ... ))` around it converts the string
"      3" into the integer 3, which makes the output identical on macOS and Linux.

## Where it shows up

Export pipelines, backup verification ("a 0-byte archive is not a backup"),
log checks, and any process where a silent empty result is worse than a loud
failure. The habit to take with you: validate the output of a step before you
trust it.

## Going further

Another check that pipelines love is staleness: is this output older than its
input? That is next, and it compares timestamps.

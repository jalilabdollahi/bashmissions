# Debrief: Usage and --help

Good tools answer three questions without a manual: what do you do, how do I call
you, and what did I do wrong. A `usage()` function is the smallest way to answer
them, and the split it creates is the important part: asking for help is a success
(stdout, status 0, so `ticket.sh --help | less` works), while a bad call is a
failure (stderr, status 2, so a calling script can detect it and so the text never
pollutes a pipe that expects data).

Under the hood nothing special happens. A function is a named block of commands;
`usage >&2` redirects the output of every command inside it, which is why one
function can serve both paths. `$#` holds the argument count, and `${1:-}` is a
parameter expansion that supplies an empty default so `set -u` stays quiet while
you test for flags.

Real tools follow the same convention: `git` prints usage on stderr with status 129,
`grep` exits 2 on bad invocation. Putting validation first also means a typo never
reaches the dangerous part of the script.

Going further: with one help flag you can get away with a `case`. When a tool grows
options with values (`-o FILE`), you need a proper parsing loop; that arrives in
level 283.

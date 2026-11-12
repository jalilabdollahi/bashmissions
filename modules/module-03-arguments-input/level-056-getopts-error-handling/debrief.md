# Debrief: getopts Error Handling

A parser is only as good as its failure behaviour. The leading colon moves error
handling from `getopts` to *you*: every mistake the user can make reaches your
`case` as either `?` (unknown option) or `:` (missing value), with the culprit in
`$OPTARG`. You choose the message, the stream (stderr), and the exit status.

The distinction between validation layers is worth keeping in mind. `getopts`
checks *syntax*: is this a known letter, does it have its value? Your own checks
after the loop check *meaning*: is the required host present, is the port a
number (level 50's regex fits right in), is the quiet flag allowed with this
combination? Syntax errors are caught inside the loop, meaning errors outside.

Exit status 2 for misuse is a convention that automation can trust: a cron
wrapper can treat 2 as "someone typed it wrong, do not retry".

With this level you can build a command-line interface that behaves like the
standard tools: defaults, switches, values, bundling, clear errors. You now know
how scripts receive everything from the outside world.

Going further: module 4 adds the missing ingredient, making decisions beyond the
one-line guards, with `if`, `elif` and `case` in full.

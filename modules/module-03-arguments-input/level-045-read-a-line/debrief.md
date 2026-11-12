# Debrief: Read a Line

Every program has three standard streams: input (stdin), output (stdout) and
errors (stderr). Until now your scripts only used the last two plus arguments.
`read` is how a script consumes the first one. Each call takes exactly one line,
up to the newline, so calling it again reads the next line.

The `-r` flag matters more than it looks. Without it, `read` is a relic from the
1970s that interprets backslashes as line continuations and escapes, silently
changing the data. A good habit is to type `read -r` every time, the way you type
quotes around variables.

Under the hood `read` also splits the line on whitespace when you give it several
variable names (level 47) and trims leading and trailing spaces for a single
variable. If you must keep those, the idiom is `IFS= read -r line`.

Where it shows up: scripts that sit at the end of a pipe, installer questions,
and hooks that the surrounding system feeds data to.

Going further: when a person is typing, a prompt helps them understand what to
enter. That is the next level.

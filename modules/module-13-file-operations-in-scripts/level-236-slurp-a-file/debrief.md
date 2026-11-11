# Debrief: Slurp a File

## What you learned

A file does not have to be processed through a pipeline. For small files
(tokens, version strings, one-line configs, PID files) the shell can load the
content straight into a variable with `$(<file)` and treat it like any other
string.

## Under the hood

When the shell sees `$(<file)` it opens the file itself, reads it to the end
and substitutes the text. Because it is a *command substitution*, it
inherits one famous rule: trailing newlines are stripped. Newlines in the
middle stay. A file with no final newline loses nothing.

The word "slurp" is a warning too: the whole file sits in memory. A
two-gigabyte log slurped into a variable is a bad afternoon. Reserve this
for small inputs; use loops or pipes for big ones.

## In real work

`version=$(<VERSION)`, `pid=$(<app.pid)`, `hostname=$(<hostname.txt)` appear
in build and deploy scripts all the time. A good habit is to check that the
file exists first, since a missing file yields an error and an empty value.

## Going further

Sometimes you want just one line out of a big file instead of all of it.
Next: picking line number N with `sed`.

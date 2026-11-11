# Debrief: PS4 with Line Numbers

Every shell has a handful of prompt variables. PS1 is the one you see at the
terminal; PS4 is the one Bash prints in front of each trace line. It defaults to
`+ `, and because it is an ordinary variable you can fill it with anything the
shell can expand.

The important detail is *when* the expansion happens. Bash does not expand PS4
when you assign it. It expands PS4 each time it is about to print a trace line.
That is why the assignment must use single quotes: they hold `${LINENO}` back
until trace time, when it holds the line number of the command being traced.
In double quotes you would freeze one number into the prefix and all your trace
lines would lie in the same way.

You will see the same trick in professional scripts, usually with more in it:
`PS4='+ ${BASH_SOURCE##*/}:${LINENO}: '` shows file and line, and adding
`${FUNCNAME[0]}` shows the function. When the command is nested (a command
substitution, say), Bash repeats the first character of PS4 to show the depth,
which is why the default is a single `+`.

Where it shows up: any long deploy or cron script that needs to be debugged
from a log. A trace with line numbers can be matched to the source in seconds.

Going further: `$LINENO` is useful in your own messages, not just in the
trace. That is the next level.

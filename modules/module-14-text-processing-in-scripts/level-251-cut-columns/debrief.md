# Debrief: Cut Columns

Most data you meet in operations is a table pretending to be text: logs, CSV
exports, `/etc/passwd`, the output of `ls -l`. The Unix answer is to treat it as
a stream of lines, and each line as a row of fields split by a delimiter. `cut`
is the simplest tool in that family. It reads lines, splits each one at the
delimiter you give with `-d`, and prints the fields you name with `-f`.

Under the hood nothing is parsed or understood: `cut` just counts delimiters.
That makes it fast and predictable, and also explains its limits. It cannot
reorder columns (`-f5,2` still prints field 2 first), and it has no idea about
quoting, so a CSV cell like `"Smith, John"` is cut in half. For simple exports
like this one, it is perfect.

You will use it constantly: `cut -d: -f1 /etc/passwd` lists accounts,
`cut -d' ' -f1 access.log` lists client addresses. Because it reads standard
input when given no file, it slots into pipelines, which is where the next
levels take you.

Going further: once you have a column, you usually want it ordered. The next
level sorts lines, and later ones count them.

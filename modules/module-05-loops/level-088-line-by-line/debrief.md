# Debrief: Line by Line

`while IFS= read -r line` is the standard idiom for reading text, and every piece of it has a reason. Learn it as a whole phrase and you will use it for the rest of your Bash life.

## How it works
`read` consumes one line from standard input each time it runs. When there are no more lines it returns a failure status, and that is what stops the `while`. The redirect `< "$file"` after `done` connects the file to the whole loop, so the file is opened once and each `read` continues where the previous one stopped.

By default `read` splits the line into words using `IFS` (space, tab, newline) and strips those characters from the ends. Setting `IFS=` only for that command (the assignment is not permanent) turns the stripping off. Without `-r`, a backslash at the end of a line joins it with the next line and `\t` loses its backslash. With `-r` the text arrives untouched.

One known limit: a last line without a final newline is not delivered by plain `read`. For well-formed text files this does not matter.

## In real work
Config parsing, importing lists of users or hosts, processing logs, reading the output of other tools. Anywhere text arrives in lines.

## Going further
Next you will count how many of those lines meet a condition.

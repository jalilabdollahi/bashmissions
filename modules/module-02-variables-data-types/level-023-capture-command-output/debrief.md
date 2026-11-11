# Debrief: Capture Command Output

## What you learned
`var=$(command)` turns what a command prints into a value you can keep. Commands produce text; variables hold text; `$(...)` is the bridge between the two.

## Under the hood
Bash starts the command inside `$( )` in a subshell, reads everything it writes to standard output, strips trailing newlines and substitutes the result in place. Standard error is not captured, so error messages still reach the terminal. The captured value is a snapshot: if the file changes later, the variable does not.

Inside an assignment the result is not word-split, so no quotes are needed on the right-hand side. When you use the variable in a command afterwards, quoting rules apply again.

## In real work
Scripts capture the date, a hostname, a file count, a version string, the output of `grep`. Running a command once and storing the result is both faster and safer than running it three times and hoping it answers the same way.

## Going further
Some values should never change after you capture them. The next level locks a variable so nothing can overwrite it.

# Debrief: Glue Strings Together

## What you learned
Concatenation in Bash is just adjacency: put text and `$variables` next to each other. `+=` is a shorthand for "set this variable to its old value followed by the new text".

## Under the hood
`url+=:$PORT` is expanded first (the `$PORT` becomes its value) and then appended. The assignment itself does not split words, so you can write the right-hand side without quotes. As soon as you use the value in a command, quote it again.

Notice what you did not have to do: no function, no `join`, no `+` between strings. The shell treats everything as text. (That changes when we get to numbers; `+=` on an integer variable adds, which you will meet in the integer level.)

## In real work
Scripts assemble things constantly: command options, file paths, SQL, log lines. Building a string piece by piece makes each piece easy to read and easy to change.

## Going further
So far every value was typed in or passed in from outside. Next, you will let a command produce the value.

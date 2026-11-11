# Debrief: Read-Only Settings

## What you learned
`readonly NAME=value` freezes a variable for the rest of the script. It is the shell's version of a constant: the value is chosen once, and any later assignment is an error instead of a silent change.

## Under the hood
Bash keeps a flag on each variable. Every assignment checks that flag first. For a read-only variable the assignment fails: Bash writes `readonly variable` to stderr, the assignment returns a non-zero status, and the value stays as it was. The script itself keeps running unless something checks that status (later modules do exactly that). A read-only flag cannot be removed, and not even `unset` can delete the variable. It also is not exported to child processes automatically; you will meet exporting in a few levels.

## In real work
Use `readonly` for things that must not drift: configuration read at the top of a script, directories you are about to delete from, a lock file name, a retention period. A bug that tries to change them now leaves a message at the exact bad line instead of silently corrupting the value three steps later.

## Going further
Next you will do the opposite: remove a variable, and learn how to ask Bash whether a variable exists at all.

# Debrief: Assign a Default

## What you learned
`${var:=default}` is "fallback plus remember": when the variable is unset or empty, Bash both substitutes the default and stores it in the variable. The `:` command is just the harmless place where you evaluate it.

## Under the hood
Parameter expansion happens before a command runs, and `:=` is the one expansion with a side effect on the shell's variable table. The colon command (`:`) is a built-in that returns success without doing anything, so `: "${VAR:=x}"` has no output and no effect except the assignment. Leaving out the quotes would also work for simple defaults, but quotes keep spaces in the default intact.

Only variables can be assigned this way. Special parameters like `$1` and `$?` cannot, which is why you will not see this form with positional arguments.

## In real work
Put a block of these at the top of a script, one per setting, and the rest of the script can ignore the question "was it provided?" entirely. The block doubles as documentation of what the script needs.

## Going further
Sometimes there is no sensible default, and carrying on without a value would be dangerous. The next level makes the script refuse to continue.

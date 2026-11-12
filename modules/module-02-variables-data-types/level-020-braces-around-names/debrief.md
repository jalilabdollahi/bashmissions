# Debrief: Braces Around Names

## What you learned
`${name}` is the full, unambiguous way to refer to a variable. `$name` is a shortcut that only works when whatever follows cannot be mistaken for part of the name.

## Under the hood
Before running a command, Bash scans each word for `$`. After the dollar it greedily collects every letter, digit and underscore. A missing variable is not an error - it quietly becomes an empty string, which is why this bug is so easy to ship: nothing crashes, the file is just called `.tar.gz`.

With braces, the name is exactly what sits between `{` and `}`. The braces are also the doorway to the special forms you will meet in this module, like `${name:-fallback}`.

## In real work
Build file names, log paths and hostnames with braces: `/var/log/${service}_${date}.log`. It also makes scripts easier to read, because the variable stands out from the text around it.

## Going further
Braces solve "where does the name end". The next level solves a more dangerous problem: what happens when the value itself contains spaces.

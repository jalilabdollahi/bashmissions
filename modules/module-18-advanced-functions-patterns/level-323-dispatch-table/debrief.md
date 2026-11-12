# Debrief: Dispatch Table

You separated *which* code runs from *how* it gets found. The table is data:
keys on the left, function names on the right. The dispatcher is three lines
that never need to change when you add a command.

## Under the hood

An associative array is a hash map. `${commands[$name]}` hashes the key and
returns the stored string. Nothing here is special about functions: the table
stores plain text, and `"$fn" "$@"` simply uses that text as a command name.
Because the word is expanded before Bash looks for a command, the lookup
result works exactly like typing the function name. Quote it, so that an
odd value cannot split into several words.

`shift` is the other half of the trick: it drops the command name so that
`"$@"` carries only the command's own arguments, untouched.

## In real work

Every multi-command tool is built this way: `git`, `docker`, `systemctl`.
Shell front doors keep their tables in an array so that `help` can print
`"${!commands[@]}"` and tab completion can read it. Deploy scripts map
environment names to config functions the same way.

## Going further

The table only knows commands you wrote down in the same file. In the next
level the table grows by itself: every file dropped in a folder can register
more commands, a plugin loader.

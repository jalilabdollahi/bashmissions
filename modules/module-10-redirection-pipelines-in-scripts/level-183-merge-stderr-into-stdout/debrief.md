# Debrief: Merge stderr into stdout

## What you learned

`2>&1` is not "merge the streams"; it is "copy the current target of 1 into
slot 2". It is an action performed at one moment, so position in the command
line is meaning. Read redirections left to right like a recipe.

## Under the hood

The shell calls `dup2(1, 2)`: slot 2 becomes a duplicate of whatever slot 1
refers to at that instant. Later changes to slot 1 do not follow. So
`2>&1 > file` duplicates the terminal into 2 first and only then moves 1 to
the file. A mnemonic: in `> file 2>&1`, "file" is read first, so "2 goes where
1 now goes: the file".

The `&` in `2>&1` tells the shell the right-hand side is a descriptor number,
not a file called `1`.

## In real work

This exact phrase appears in cron lines, Dockerfiles and systemd wrappers. In
a pipe it works the other way around too: `cmd 2>&1 | grep error` sends both
streams into the pipe.

## Going further

Not every stream deserves to be kept. Next: how to throw output away on
purpose with `/dev/null`.

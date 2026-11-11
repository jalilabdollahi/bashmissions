# Debrief: Loop over Files

A glob is a pattern the shell expands into matching file names before the command runs. In a `for` loop, the expanded names become the list.

## How it works
`*` matches any run of characters, `?` one character, `[abc]` one of a set. The expansion is alphabetical (in the C locale, by byte value) and happens once. Each match is already one word, so spaces in file names are no problem as long as you quote the variable when you use it.

The empty case is the trap. When nothing matches, Bash passes the pattern through unchanged, so the loop sees a "file" named `logs/*.log`. `shopt -s nullglob` changes that rule: no match, no words, no rounds. A related option, `failglob`, makes it an error instead. Pick the one that matches the behaviour you want.

Hidden files (starting with a dot) are not matched by `*` unless you enable `dotglob`.

## In real work
Rotating logs, converting every image in a folder, checking every `.conf` file, cleaning old backups. Scripts that process "whatever is in this folder" start with a glob loop.

## Going further
Files have contents too. In the next level you read a file line by line, the safe way.

# Debrief: Does It Exist?

Before a script touches a file, it should know what is there. The file tests
turn the file system into yes/no questions that `if` can ask, and they are the
backbone of every careful installer, backup and cleanup script.

## Under the hood

These tests are provided by Bash itself and call the operating system to look
at the path's metadata (the "inode"): does a name exist, and what type is it? A
Unix path can be a regular file, a directory, a symbolic link, a device, a
named pipe or a socket. `-f` and `-d` check for the two most common types, and
`-e` is the catch-all. By default they follow symbolic links, so `-f` on a link
to a file is true; `-L` asks whether the path itself is a link.

The tests only look. They do not change anything, so asking them is always safe,
and they never print an error for a missing path, which makes them ideal for
guard clauses.

## Where it shows up

"Create the directory unless it exists", "refuse to overwrite a file", "skip the
backup if the source is missing", and checking that a config file is present
before you source it.

## Going further

Existing is only the first question. A file you cannot read or run is as useless
as a missing one. Next level: permissions.

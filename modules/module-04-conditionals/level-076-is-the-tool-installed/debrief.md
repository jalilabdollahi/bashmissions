# Debrief: Is the Tool Installed?

A script is only as portable as the tools it assumes. `command -v` is the
standard, portable way to ask "does this exist?", and it is the first line
of defence in every installer, CI job and setup script.

## Under the hood

When you type a command, Bash looks it up in a fixed order: aliases, shell
functions, built-ins, and finally the directories of `$PATH`. `command -v`
performs the same lookup without running anything, and reports what it found.
That makes it more accurate than `which`, which only searches `$PATH` and so
misses built-ins and functions. If nothing is found, it exits with status 1,
so `if command -v ...` works without any output parsing.

The redirection `>/dev/null 2>&1` throws away standard output and errors. The
decision you want is in the exit status, not in the text.

## Where it shows up

`command -v curl || { echo "need curl" >&2; exit 1; }` at the top of a script,
choosing between `gdate` and `date`, picking the first available editor, and
feature detection in dotfiles that must work on both macOS and Linux.

## Going further

Even when the tool exists, the system around it may differ: macOS and Linux
disagree on flags and paths. Next level: decide based on the platform.

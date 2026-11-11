# Debrief: Loop over Arguments

Loops and arguments fit together: the arguments are the list. The one thing to get right is how that list is split into words.

## How it works
Bash has two ways to expand all arguments. `"$@"` produces one word per argument, preserving each exactly. `$@` and `$*` without quotes are subject to word splitting and filename expansion, which tears "Gull & Anchor Pub" into three words and may even turn a `*` into a list of files. The quoted form is the one you almost always want.

The same rule applies to the loop variable. `$name` unquoted in the body is split again, so write `"$name"` wherever you use it as one thing: in a path, an argument to another command, a test.

`$#` tells you how many arguments came in. Checking it before the loop lets you print a helpful usage message instead of silently doing nothing.

## In real work
Scripts that take a list of hosts, files, users or tickets all follow this skeleton: validate, then `for x in "$@"`. It is the entry point of most command-line tools.

## Going further
Instead of names that the user types, you may want to act on files that are already on disk. Level 87 loops over file names found by a glob.

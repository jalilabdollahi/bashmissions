# Debrief: mapfile from a File

`mapfile -t arr < file` turns the lines of a file into the elements of an array: one line, one element, no word splitting, no globbing.

## How it works
`mapfile` (also spelled `readarray`) is a built-in that reads standard input until the end and stores each line as an element. The `< file` redirect gives it the file as that input. `-t` is almost always wanted: by default each element keeps its newline character, which then sticks to every comparison and printout.

Compare with `arr=($(cat file))`. Command substitution produces one big string, and the unquoted array assignment splits it at every whitespace character and expands wildcards. Names with spaces break, blank lines disappear, and a line holding `*` turns into a directory listing. With `mapfile` the line boundary is the only boundary.

The array is created in the current shell because the redirect, not a pipe, feeds it. Put a pipe in front (`cat f | mapfile -t a`) and the array is filled in a subshell and lost, the same trap as in level 94.

## In real work
Host lists, allow-lists, a file of paths for a batch job, the lines of a log you want to inspect by index.

## Going further
What if the lines come from a command rather than a file? The next level uses process substitution to feed `mapfile` from a command's output.

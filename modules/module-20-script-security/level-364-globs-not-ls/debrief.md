# Debrief: Globs Not ls

File names are the one piece of "user input" that arrives on every system without
anybody typing it. Anyone who can upload, extract an archive or create a file can
choose a name containing spaces, newlines, leading dashes, quotes or `$(...)`. A
script that gets its file list by parsing text is trusting those names to behave.

A glob is different in kind: the shell reads the directory itself and produces
one list element per entry. Nothing is re-split or re-parsed, so `a*b.log` stays
`a*b.log` and `Harbour Bakery.log` stays whole. Two details finish the job.
`nullglob` makes an unmatched pattern vanish instead of staying as text, and
tests such as `-f` filter the results (a folder can end in `.log` too). A third
habit applies later: put the folder in front (`"$dir"/*.log`), because it also
stops a name like `-n.log` from reaching a command as an option.

Attack mental model: *what file names can I make that change what a command
does?* Leading dashes become options, spaces become extra arguments, newlines
break line-based parsing, and `;` or `$()` matter anywhere a name reaches a
second shell.

Going further: when the loop writes to files, a name can also be a symlink that
points somewhere you never meant. Level 365 checks for that before any write.

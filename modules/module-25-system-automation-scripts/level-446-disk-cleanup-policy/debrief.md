# Debrief: Disk Cleanup Policy

## What you learned

Separating rules from code makes automation reviewable: Priya can read three lines of policy without reading a script. You also met two production habits: validate the entire input before taking any irreversible action, and make the dry run produce the same numbers as the real run.

## Under the hood

`find` evaluates its tests left to right and combines them with AND, so `-type f -name '*.dump' -mtime +30 -size +1000c` means all four must hold. The size unit matters: without `c`, `-size` counts 512-byte blocks and rounds up. `-mtime +N` is in whole days, rounded down, so `+7` means eight days or older. Passing the pattern in quotes defers wildcard expansion to find, which matches names at every depth; an unquoted `*.tmp` would be expanded by the shell in the current folder first.

An array of arguments is the safe way to build a command conditionally, since each element stays one word.

## In real work

Mature cleanup scripts add a safety valve (abort if the rules would delete more than N files or a percentage of the disk), log what they delete, and exclude paths that must never be touched.

## Going further

Cleanup rules look at files; the next level looks at software. You will compare installed packages with a policy.

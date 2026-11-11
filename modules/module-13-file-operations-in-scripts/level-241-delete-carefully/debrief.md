# Debrief: Delete Carefully

## What you learned

Destructive commands deserve a guard clause for every way the input can be
wrong. The two mental tools: **validate the *resolved* value, not the text**
(`shared/../secret` fools a text check), and **make the dangerous command
the last line, reachable only after every check**.

## Under the hood

The shell expands variables and wildcards *before* `rm` starts; `rm` never
sees the variable, only the result. That is why an empty `$dir` in
`"$dir/"*` silently becomes `/*`. `pwd -P` reports the physical path with all
symlinks resolved (plain `pwd` may keep the logical path you typed), which
is exactly what you want when asking "where would this delete land?".

Matching `"$resolved/"` against `"$base"/*` includes the trailing slash so a
folder like `shared-backup` does not pass as "inside shared".

## In real work

Deploy and cleanup scripts all grow guards like these. Common companions:
`${var:?message}` to stop on empty variables, a dry-run mode that only
echoes the `rm`, and `set -u` so a typo in a variable name is an error.

## Going further

Cleanup scripts also create their own scratch space. Next: temporary files
that are named safely and never collide.

# Debrief: Find by Name

## What you learned

`find` is the tool for "everything under here that looks like this". The
mental model: it walks the tree, and for each entry evaluates your tests left
to right, printing the entry if all are true. `-name` is the first test you
learn; more follow in the next levels.

The most common trap is not `find` itself but the shell in front of it: a
wildcard you meant for `find` gets expanded by the shell first. Quote it.

## Under the hood

The shell expands unquoted `*`, `?` and `[...]` *before* running a command,
using the current directory. `find` then receives the results, not the
pattern. Quoting (`"$pattern"` or `'*.conf'`) hides the wildcard from the
shell so `find` can apply it itself to every name it visits.

`-name` matches the file's own name only. `find -name 'srv/*.conf'` finds
nothing, because no name contains a slash. To match on the whole path there
is `-path`.

`find`'s output order is not sorted and can differ between Linux and macOS,
so always sort when the order matters.

## In real work

Auditing configs, cleaning old logs, locating a customer's files: `find ... -name`
is the first step in most clean-up scripts. Combined with `-type` and `-size`,
which come next, it is nearly a query language for the file system.

## Going further

Names are only one property. Next: restricting by type (file or folder) and by size.

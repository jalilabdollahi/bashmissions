# Debrief: Batch Rename

## What you learned

Bulk operations are a loop over a glob with a small piece of string surgery
inside. The new name is *computed* from the old one: `${f%.old}.new`. And
every bulk operation that can destroy data needs a guard, here "does the
target already exist?".

## Under the hood

The shell, not `mv`, expands `*.jpeg`: by the time `mv` runs, the pattern
has been replaced by the real names, each as one argument, spaces included.
That expansion happens in sorted order, which is why this level's output has
a stable order. `mv` on the same disk only edits a directory entry: it is
instant and does not copy any data.

`%` and `#` are mirror images: `%` trims from the end, `#` from the start;
doubling them (`%%`, `##`) makes them greedy. `${path##*/}` is the classic
"just the file name".

## In real work

Renaming extensions, adding date prefixes, normalising names for a web
server. Always run a rename script first with `echo mv ...` to see the plan,
then drop the `echo`.

## Going further

Renaming is gentle. Deleting is not. Next: removing files, and why a single
empty variable can ruin your week.

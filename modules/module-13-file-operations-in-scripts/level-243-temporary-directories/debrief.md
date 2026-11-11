# Debrief: Temporary Directories

## What you learned

A temporary *directory* is a private workshop. You can create files, rename
them, even build a whole tree in it without worrying about names, and one
`rm -rf` on the way out cleans everything. It turns "build, then ship the
result" scripts into something tidy and repeatable.

## Under the hood

`mktemp -d` makes the folder with mode 700, so other users cannot even list
it. The `trap ... EXIT` handler is your guarantee of cleanup, and the guard
`${stage:?}` is what makes `rm -rf` on a variable acceptable: if the
variable were empty you would get an error, not `rm -rf ""` or worse.

The `( cd dir && command )` form runs in a *subshell*, a child copy of the
shell. Its `cd` disappears when it ends, so the main script keeps its
original working directory. That is why the output path had to be made
absolute first.

## In real work

CI jobs, installers and release scripts all stage in a temp dir: unpack,
patch, test, package. If the step before the final copy fails, the real
target was never touched.

## Going further

Now that your scripts can create things safely, let's go and look for
things. Next: `find` by name.

# Debrief: cd Without Consequences

## What you learned

The current working directory is a property of a *process*. A subshell has its
own copy, so a `cd` inside `( ... )` moves only that child. That makes
`( cd dir && command )` the safest way to "run something over there": there is
nothing to undo, even if the command fails or the script is interrupted
halfway.

## Under the hood

When the shell forks a subshell, the child inherits the parent's working
directory as a starting value. `cd` then calls `chdir()` on the *child*. The
parent's directory is a separate number in a separate process, which no child
can modify. The same holds for every program you run: `sitebuild` could `cd`
to the moon and your script would not notice.

A subshell's exit status is the status of the last command it ran, so
`( cd "$d" && make )` is a single yes/no result for "did it all work?", which
is why it fits an `if`.

## In real work

Build scripts, deploy loops over many project folders and anything that
processes "each directory" use this idiom. It also pairs with background jobs:
`( cd "$d" && build ) &` gives every job its own folder without any
interference.

## Going further

Subshells isolate. Sometimes you want the opposite: group commands but keep
them in the current shell, for example to share a single redirection.

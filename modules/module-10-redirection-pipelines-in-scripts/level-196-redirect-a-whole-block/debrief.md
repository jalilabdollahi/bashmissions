# Debrief: Redirect a Whole Block

## What you learned

Redirection is not limited to a single command. Any compound command, a
`{ ...; }` group, a loop, an `if`, a `while read`, can carry redirections on
its closing keyword, and they apply to everything inside.

## Under the hood

Before running the group, the shell opens the target files and installs them as
descriptors 1 and 2, then runs the commands one after another in the current
shell, then restores the old descriptors. In other words, it is the tidy form
of `exec 4>&1; exec > file; ...; exec 1>&4 4>&-` from the previous level, with
the saving and restoring done for you.

Because the files are opened once, you get one clean report and no risk of a
mid-script `>` wiping what came before.

## In real work

Generating a report from several commands, writing a config file piece by
piece, capturing the output of a whole function (`myfunc > out.log`), or
`while read ...; done < file`, which is the same idea on a loop.

## Going further

You now control all three standard streams, files, pipes and your own
descriptors. Next module: making scripts safe to run, because the lesson
of these levels is that streams carry the errors you need to see.

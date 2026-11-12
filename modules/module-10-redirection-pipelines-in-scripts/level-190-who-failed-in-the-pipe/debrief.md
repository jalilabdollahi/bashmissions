# Debrief: Who Failed in the Pipe?

## What you learned

Every command in a pipeline is a separate process with its own exit status.
The shell normally reports only the last one. `PIPESTATUS` is where Bash keeps
all of them, as an array, until the next command replaces it.

## Under the hood

When a pipeline finishes, the shell collects each child's status and stores
them in `PIPESTATUS`. Any later command, even `echo` or a variable assignment
that runs a command, resets the array to that command's single status. Copying
into another array is the only safe way to use it twice.

All three stages also ran concurrently: stage 2 does not wait for stage 1 to
succeed. That is why a failed fetch still let scrub and ship run on its
partial output, and why a status-only check at the end is not enough.

## In real work

Backup pipelines (`dump | gzip | upload`), deploy chains, log processing.
Use `pipefail` as a safety net and `PIPESTATUS` when you need the details for
an alert or a retry.

## Going further

Pipelines connect commands one-way. Next, pipelines' cousin: process
substitution, which lets a command's output appear as a file name.

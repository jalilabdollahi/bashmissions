# Debrief: Background Jobs and wait

Until now every command waited for the one before it. A trailing `&` breaks that rule: the shell starts the command and immediately moves on, so several jobs can run at the same time.

## How it works
A background job is a separate process. The script keeps running, and `wait` is the synchronisation point: it blocks until all background children have exited (or until specific ones, if you pass their process ids, `wait $pid`). Skip it and the script may end, or read results, before the jobs have finished.

Parallel jobs finish in no fixed order, so their output cannot be trusted to appear in the order of the arguments. Two classic remedies exist: collect each result in its own file or array slot and print after `wait`, or sort the combined output. Both turn nondeterministic timing into deterministic output, which is the difference between a script you can test and one you hope works.

Parallelism is not free. Fifty simultaneous probes may overwhelm the machine or the network, so real scripts limit how many run at once. Background jobs also lose the exit status of the command unless you collect it with `wait $pid`.

Notice what you have built across this module: a list loop, counting loops, loops over input and files, searches, and now loops that fan work out. That is most of what automation is made of.

## In real work
Health sweeps, uploading many files, running the same command on every server, rendering batches of reports.

## Going further
Module 6 packages repeated code into functions, so the pieces you wrote here can be reused by name.

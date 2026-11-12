# Debrief: Ignore and Restore Signals

## What you learned

`trap '' SIG` ignores a signal, `trap - SIG` puts the default action back, and
`trap handler SIG` installs your own reaction. Ignoring is the heavy tool:
the kernel itself records "this signal is ignored" for the process, and that
record is copied to every child, even across `exec`.

## Under the hood

A process has, per signal, one of three dispositions: default, ignore or
catch. A *caught* signal cannot survive `exec` (the old code with the handler
is gone), so children of a script with a handler get the default back. The
*ignored* state is a flag, so it is inherited. This is how `nohup` works: it
ignores SIGHUP and then runs your command, which keeps ignoring it.

Two signals cannot be ignored or caught at all: SIGKILL and SIGSTOP. That is
why `kill -9` always works. A shield against TERM is a promise to the operator
that you will finish important work, not a security measure.

Remember to lift the shield. A script that keeps TERM ignored forever
cannot be stopped politely by anyone.

## In real work

Short critical sections (flipping a symlink, committing a state file, finishing a
database migration) are the classic place to ignore INT and TERM, then
restore. Background jobs started by scripts often ignore HUP so they outlive the
terminal.

## Going further

You have mastered one script and its children. Now let several worker
processes cooperate on a list of tasks, starting with the easiest tool: `xargs -P`.

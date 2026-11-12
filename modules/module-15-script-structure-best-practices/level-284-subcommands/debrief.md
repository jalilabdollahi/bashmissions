# Debrief: Subcommands

`git commit`, `docker run`, `systemctl restart`: one executable, many verbs. The
design is simple and scales well. The first argument names an action, `shift` removes
it, and the remaining arguments belong to that action. Each verb is an ordinary
function with its own argument rules and error messages, and a top-level `case` is
the only place that knows the full list. Adding a verb is two edits: a function and a
branch.

Notice what the structure buys you. The dispatcher validates the verb (unknown ones
exit 2, like any bad invocation); each verb validates its own arguments (a bad note
number exits 1, because the request was well-formed but could not be satisfied).
Functions can share helpers such as `usage`, and the shared constant `NOTES` appears
only once. Because `cmd_remove` writes a new file and renames it, a failure halfway
never leaves a half-written notes file behind.

The same shape appears in service scripts (`start|stop|restart|status`), deployment
helpers and any "toolbox" script a team passes around. If each subcommand also gets
its own options, run the level 283 option loop inside the verb function.

Going further: stateful tools raise a question: what happens if the command runs
twice? Level 286 makes scripts safe to repeat.

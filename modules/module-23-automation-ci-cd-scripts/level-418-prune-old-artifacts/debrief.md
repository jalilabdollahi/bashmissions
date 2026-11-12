# Debrief: Prune Old Artifacts

The mental model: **names are data, and data must stay in arrays.** The moment a
list of file names passes through a text pipeline (`ls | tail | xargs`) it is
re-split on whitespace and re-parsed for options, and a cleanup script that
misreads one name deletes the wrong file. A glob into an array never leaves
Bash's own data structures, so `release notes.tar` stays one element.

Ranking by comparison is the portable way to order by time. `ls -t` is
convenient but unusable as input; `stat` and `find -printf` differ between GNU
and BSD. The test `[[ a -nt b ]]` is built in and behaves the same everywhere.
Counting "how many are newer" gives each file a rank without sorting at all.

Deleting is the dangerous verb, so the script follows a few habits: decide first,
act second; delete only paths it built itself from the glob; protect against
dash-leading names with `--`; restrict itself to regular files so it cannot
follow a symlink out of the folder; and print what it did so a log shows exactly
what went.

Retention policies like this one run in every artifact store, log rotation and
backup system: keep the last N, or the last N days.

That completes the module: you can now test, version, build, package, deploy,
roll back, schedule and clean up, entirely with scripts you wrote and understand.

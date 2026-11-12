# Common Mistakes

- **Passing the trace and parent ids as arguments.** Every command in between would need to know about them. Put them in the environment of the child: `OBS_TRACE=$t OBS_PARENT=$s "$@"`.
- **Exporting for the whole script.** `export OBS_PARENT=...` changes your own later behaviour too. Prefix only the one command, or the next sibling span gets the wrong parent.
- **Assuming the spans file is ordered by start.** Spans are appended when they finish, so children come before parents. Build the tree from the parent ids.
- **Sorting `t10` and `t2` as text.** The plain sort puts `t10` first. Sort on the numeric part: `sort -t t -k2,2n`.
- **Allocating ids after running the command.** If the command fails or crashes, the next run reuses the id. Allocate first, persist, then run.
- **Losing the exit status.** `"$@" || true` or logging after the command overwrites `$?`. Capture it right away: `status=0; "$@" || status=$?`, and exit with it at the end.
- **Writing counters in place.** `echo ... > metrics.txt` truncates first; a concurrent reader or a crash sees an empty file. Use a temp file and `mv -f`.

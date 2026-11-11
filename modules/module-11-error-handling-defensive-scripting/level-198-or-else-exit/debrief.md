# Debrief: Or Else Exit

By default a Bash script is optimistic: a command fails, the error scrolls past
and the next line runs as if nothing happened. That is fine at the keyboard,
where you see the error and stop. In a script nobody is watching, the next line
runs in a world that no longer matches what the author assumed.

`cmd || action` is the smallest tool against that. The `||` operator looks at the
exit status of the left side (the same `$?` you read in the previous level) and
runs the right side only for a non-zero status. With `exit 1` on the right, the
script dies at the exact line where the assumption broke, with a message that
says why.

The most important places to guard are the commands that change where or what
later commands act on: `cd`, `mkdir`, `cp` before an `rm`, a download before an
unpack. A cheap rule of thumb: if the next line is destructive, the line before it
deserves a guard.

Real-world bite: the famous `cd "$DIR"; rm -rf *` pattern has erased home
directories and build servers because `$DIR` was empty or missing.

Going further: writing `|| exit` after every line gets repetitive. The next level
shows how to ask Bash to do it for you, and where that shortcut surprises people.

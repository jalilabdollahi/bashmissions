# Debrief: Stop at the First Match

Searching is the most common reason to leave a loop early. The shape never changes: examine, remember, break, then judge what you remember.

## How it works
`grep -q` turns a text search into a yes/no question. `if` runs a command and branches on its exit status, so `if grep -q ... "$file"` reads as "if this file contains the pattern". Anchors make the question precise: `^` ties the pattern to the start of a line, which excludes comments and indented notes.

The variable `hit` is the loop's message to the code after it. Bash has no "loop result", so you carry it out yourself with a variable that starts empty. When the loop ends because the list was exhausted, `hit` is still empty; when it ends because of `break`, `hit` holds the file. Checking `-n` after the loop distinguishes both.

Stopping early saves time on long lists and slow checks (network calls, big files), and it gives the "first match" meaning: the order of the arguments decides who wins.

Exit statuses are part of the interface. `exit 1` for "not found" lets other scripts, or `if ./check.sh ...`, react without parsing your text.

## In real work
Finding the first server that has a version installed, the first failing health check, the first config containing a forbidden setting.

## Going further
The last level goes the other way: instead of one at a time, start everything at once and wait for all of it.

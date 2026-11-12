# Debrief: Make Directories and Files

## What you learned

Good setup scripts are **idempotent**: running them once or five times leaves
the machine in the same state. `mkdir -p` and `touch` are the two everyday
building blocks for that. Neither one asks "does it exist yet?"; they are
defined so that the question does not matter.

## Under the hood

`mkdir` normally calls the system once and fails if the path is taken or a
parent is missing. With `-p` it walks the path from the left, creating each
component that is absent and skipping the ones that exist. `touch` opens the
file, creating it empty only if needed, and then sets its timestamps to now.
It never truncates, which is why it is safe on files that hold data.

## In real work

Every installer, deploy script and cron job starts with a few `mkdir -p`
lines: log folders, cache folders, output folders. `touch` shows up for
marker files ("this job has run"), for making a log writable by someone else
later, and for bumping a timestamp to trigger a rebuild.

## Going further

Creating files is the easy half. What happens when a script writes into a
file that is already there and full of important data? Next: stopping the
shell from silently overwriting.

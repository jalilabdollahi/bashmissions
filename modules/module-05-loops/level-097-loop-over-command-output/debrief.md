# Debrief: Loop over Command Output

Data often comes from a command, not a file. You want a loop that reads it line by line and still runs in your own shell. Process substitution gives you exactly that.

## How it works
`<(command)` makes Bash start the command and replace the expression with the name of a special file (on most systems something like `/dev/fd/63`) from which the output can be read. Because it behaves like a file, you can attach it with the ordinary redirect `< ...`. The result, `done < <(cmd)`, reads: "feed this loop from the output of cmd".

The decisive difference from `cmd | while read` is where the loop runs. In a pipeline the loop is a subshell; with process substitution the command is the one running on the side, and the loop stays in the main script. All your counters and trackers survive.

A small cost: the exit status of the command inside `<( )` is not visible to the loop. If you need it, capture the output first (`out=$(cmd) || exit 1`) and feed the loop with `<<< "$out"`.

The maximum tracker shows a good habit: start from a value no real data can beat (-1), and handle "no data" as a separate case instead of printing a fake maximum.

## In real work
Looping over `find` results, container lists, service status, anything one command prints per line.

## Going further
Next, generating the numbers themselves in steps, with `seq`.

# Debrief: The Pipe Subshell Trap

Variables belong to the shell that created them. A child shell receives a copy and can change its own copy freely, but nothing flows back to the parent.

## How it works
Each stage of a pipeline is started as a separate process, so that data can stream between them at the same time. Bash runs the stages in subshells. When the right-hand stage is a `while read` loop, every assignment it makes happens in a copy. The loop works, the output it prints works (stdout is shared), but the variables are discarded when the loop ends. That is why the report said `0` while the loop clearly counted.

The symptom is always the same: a counter, a total or a "found" flag that is right inside the loop and stale outside. If you ever debug a script where a variable "forgets" its value after a loop, look for a pipe in front of it.

Three ways out: redirect a file into the loop (`done < file`), use process substitution when the data comes from a command (`done < <(cmd)`), or enable `lastpipe`. All of them keep the loop in the main shell.

## In real work
This is one of the most common Bash bugs, and it passes review because the code "looks fine". It appears in log summaries, validation scripts and anything that counts.

## Going further
Level 97 handles the case where the data comes from a command, not a file.

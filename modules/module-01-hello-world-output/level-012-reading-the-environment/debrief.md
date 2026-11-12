# Debrief: Reading the Environment

A script does not run in a vacuum. It inherits a copy of its parent's environment: a list of named strings that describe where and as whom it is running.

## How it works
When one process starts another, the child gets a copy of the exported variables. The login process sets `USER`, `HOME`, `PATH` and more. Bash reads `$NAME` by looking the name up in that table and replacing the text, a step called expansion, before the command runs. If the variable does not exist, the result is an empty string and no error.

Changing a variable inside your script never changes the parent's copy. Information flows downward only.

## In real work
Environment variables are how deployment tools, cron and containers pass settings into scripts: credentials, regions, build numbers. Writing scripts that read their context instead of hard-coding it makes them reusable on every machine.

## Going further
Next, you will let a command compute a value and use its output inside your text.

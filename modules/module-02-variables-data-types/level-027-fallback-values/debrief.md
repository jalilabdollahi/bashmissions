# Debrief: Fallback Values

## What you learned
`${name:-default}` lets a line of Bash say "use this, or else that" without an if statement. It is the basic building block for making scripts work out of the box.

## Under the hood
Bash evaluates the expansion before running the command. It looks at `name`: if it is unset or empty, the whole `${...}` is replaced by the text after `:-`; otherwise by the value. Nothing is assigned. If you print `$LOG_LEVEL` on the next line it is still empty. The default is itself expanded, so you may write `${A:-$B}` to fall back to another variable.

The colon matters: `${name-default}` (no colon) only falls back when the variable is completely unset. You will take that apart in a couple of levels.

## In real work
Every well-behaved tool has defaults: a port, a directory, a timeout. Reading configuration as `${VAR:-default}` is how shell scripts get them, and it lets operators override just the one thing they care about.

## Going further
What if you want the default to stick, so later lines use it as if it had been set all along? That is the next level.

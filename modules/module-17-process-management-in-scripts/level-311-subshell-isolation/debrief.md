# Debrief: Subshell Isolation

## What you learned

`( ... )` runs a group of commands in a **child shell**. The child inherits
everything (variables, functions, the current directory) as a *copy*. It can
change its copy freely, and when it ends the changes vanish. The only things
that travel back to the parent are what it prints and its exit status. This is
the shell's fundamental rule: a child can never alter its parent.

## Under the hood

The shell calls `fork()`, which duplicates the whole process. The copy runs your
commands and exits; the parent waits for it, just as it waits for a background
job. That is why `exit 7` inside the parentheses is harmless: it ends the copy,
and the parent receives 7 in `$?`.

Compare with a pipeline: `echo hi | read x` runs `read` in a subshell too, so `x`
is empty afterwards. Command substitution `$(...)` is a subshell, and so
is every background `&` job (level 314 turns this into a technique).

Exported variables are those a child process inherits; plain shell variables
are copied into a *subshell* but not passed to external programs like `probe`.

## In real work

Temporary environments (`LC_ALL=C`, a changed `PATH`), "try something and
roll back" blocks, and background jobs all rely on subshells to keep side
effects local.

## Going further

The most useful thing to keep local is the current directory. That is next.

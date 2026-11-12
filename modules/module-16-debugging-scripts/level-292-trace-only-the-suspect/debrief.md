# Debrief: Trace Only the Suspect

`set -x` is not an all-or-nothing switch. It is a flag in the running shell, and
you can flip it at any point: commands that execute while it is on are printed,
everything else is not. A pair of `set -x` and `set +x` is a spotlight you aim at
the few lines you do not trust.

The sign is the classic trap. In `set` options, a minus turns an option on and a
plus turns it off, which is the opposite of what most people expect. You will
read it correctly after the third time you get it wrong.

Under the hood, xtrace prints a command just before it executes, and that rule
applies to `set +x` too. That is why the final trace line is `+ set +x`: the
shell traced the command that stopped the tracing. When you grep trace output in
a test, expect that line to be there.

Narrow tracing matters in real systems. A deploy script with progress messages
and many tool calls produces a wall of text under `set -x`. Scoped tracing keeps
the output small enough to read at 3 a.m. and small enough to paste into a
ticket.

Going further: the `+ ` at the start of each line is configurable. The next
level changes it so every trace line also tells you which line of the script it
came from.

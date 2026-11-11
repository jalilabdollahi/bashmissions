# Debrief: Swap Two Values

## What you learned
Assignment overwrites. A variable holds exactly one value, and storing a new one loses the old one. To exchange two values you need a third place to hold one of them while the other moves.

## Under the hood
Each assignment is evaluated in order: Bash expands the right-hand side to text, then stores it. There is no "simultaneous assignment" as in some languages (`a, b = b, a`), so the order of the three lines is the algorithm. Written in a different order, the same three lines lose data.

The same shape appears all over programming: rotating three values, keeping the previous value while computing the next, remembering the old state before an update.

## In real work
Failovers, blue/green deployments and log rotation all trade the names or roles of two things. In shell scripts you will typically see the `old=$current; current=$new` pattern: remember before you replace.

## Going further
Right now you refer to variables by writing their names. Next, you will look up a variable whose name is itself stored in another variable.

# Debrief: Terminal Status Board

Monitoring ends in front of a human, and humans read patterns, not strings.
Aligned columns make an odd value stand out in a fraction of a second, which is
the whole point of a dashboard. The craft is mostly formatting, and the core
technique is knowing a table's shape *before* printing it.

That gives the **two-pass** structure: pass one reads and measures
(collecting rows and the widest cell in each column), pass two prints. Any
program that draws a table, from `ls -l` to `docker ps`, works this way.

`printf` is your layout engine. `%-10s` means "pad to 10, left-aligned", `%5s`
"pad to 5, right-aligned" (the convention for numbers, so digits line up), and
`%-*s` takes the width from a variable, so the layout adapts to the data
instead of being hard-coded for today's server names. `printf -v var` writes into
a variable instead of the screen, which lets you assemble a row, append
markers conditionally, and print once. The `${var// /-}` replacement turns a
run of spaces into a rule.

Parallel arrays (`hosts`, `states`, `loads`, `disks`) are an ordinary Bash
idiom for "a table in memory"; `"${!hosts[@]}"` lists the indices so one loop
walks them all.

Going further: a board shows a problem; the next level fixes the simplest one
by itself: a service that has stopped.

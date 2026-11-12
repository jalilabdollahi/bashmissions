# Debrief: The Service Health Dashboard

Two ideas make this script feel professional. The first is **concurrency without chaos**.
Bash gives you background jobs (`&`) and `wait`, and that is enough, provided every job
writes to its own place and you read the results in a fixed order afterwards. Parallelism
changes *when* the work happens, never *what the output looks like*. If a wall monitor shows rows
that reshuffle on every refresh, nobody trusts it.

The second is **uniform interfaces**. Four very different checks (an HTTP request, a TCP
connection, a file's age, a disk's fullness) all answer `STATE|detail`. Add a fifth
type later and the grouping, counting, colouring and exit status do not change at all. It is the
same lesson as the plugin systems and CLI frameworks that come later in this module, in
miniature.

There are smaller lessons too: validate the config completely before running anything, pad
text before colouring it, use `df -P` and `find -mmin` for portable behaviour, and mark
what is critical so that "the board is red" actually means something. The critical marker
is a policy decision encoded in data (a `!` in a config file), not in code.

Going further: when the board turns red you will want evidence. The next mission snapshots the
system the moment an alert fires.

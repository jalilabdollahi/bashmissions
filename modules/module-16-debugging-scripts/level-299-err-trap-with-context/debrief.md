# Debrief: ERR Trap with Context

`set -e` tells a script to stop at the first failure; it does not tell anyone
*why*. The ERR trap closes that gap. It is a handler Bash runs right after a
command returns non-zero, before the shell exits, while the state of the failure
is still there to read: `$?` is the status, `$BASH_COMMAND` the command that was
running, `$LINENO` the line.

Order and quoting decide whether it works. The status must be saved on the first
command of the handler, since every command overwrites `$?`. The trap text must be
in single quotes, or Bash expands `$BASH_COMMAND` and `$LINENO` once, at the
moment you register the trap, and every report would describe the `trap` line
itself. And functions only trigger the trap if errtrace is on, which is what
the `E` in `set -eE` stands for; the same switch carries it into subshells and
command substitutions.

Conditions where Bash does not consider a failure to be one, an `if` test or the
left side of `&&`, do not fire ERR either. That is the same rule that `set -e`
follows, so the two always agree.

In the real world this gives every cron job and deploy script a self-describing
failure line to forward to a log or a chat channel, instead of a bare exit code.

Going further: instead of only reporting, sometimes a script should refuse to
change anything at all until you have seen what it would do. That is dry-run mode.

# Common Mistakes

- **Setting BASH_XTRACEFD to a descriptor that is not open.** Wrong: `BASH_XTRACEFD=3` without `exec 3>trace.log` first, which fails or loses the trace. Right: open the descriptor, then assign the number.
- **Opening the file with `>>` and expecting a fresh trace.** `exec 3>>trace.log` appends night after night. Use `>` when each run should start clean.
- **Using `exec 3>trace.log` after `set -x`.** The trace of the early commands has already gone to stderr. Set both lines up first.
- **Writing the redirection as `exec 3 > trace.log`.** The space turns `3` into a command. The digit must touch the `>`: `3>trace.log`.
- **Expecting `2>trace.log` on the command line to separate them.** That captures real warnings together with the trace. Only `BASH_XTRACEFD` splits the two.

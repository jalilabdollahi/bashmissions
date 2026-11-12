# Common Mistakes

- **Swapping the signs.** Wrong: `set +x` before the block and `set -x` after it, which traces everything else instead. Right: `set -x` to start, `set +x` to stop.
- **Forgetting to turn it off.** Wrong: `set -x` above the arithmetic and no `set +x`, so the final `echo` is traced too and stderr has an extra `+ echo 'backup took 1m'`. Right: close the block with `set +x`.
- **Being surprised by `+ set +x`.** It is traced because tracing is still active while that command runs. It is normal, not a leftover from your edits.
- **Putting `set -x` after the line you wanted.** Wrong: `elapsed=$(( $2 - $1 ))` then `set -x`: the assignment never shows. The switch affects only later commands.
- **Tracing the surrounding prints.** Wrapping the `echo` lines too makes the trace longer and hides the arithmetic you came to see. Keep the block as small as the suspicion.

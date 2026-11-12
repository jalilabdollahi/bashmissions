# Common Mistakes

- **Sourcing plugins into the host.** Wrong: `source "$plugin"` in the main shell: a plugin's `exit`, `cd` or variable assignment now changes the host. Right: `( source "$plugin"; "$fn" )` in a subshell.
- **Discovering by executing.** Wrong: running each plugin to ask what it needs. Right: read the header lines as text.
- **Ordering by file name.** Wrong: relying on `10-core`, `20-tides`. Right: sort by declared requirements, with priority and name only as tie-breakers.
- **Forgetting the cycle.** Wrong: a loop that waits for "ready" plugins and never terminates when `a` needs `b` and `b` needs `a`. Right: stop when a round finds nothing ready and report the rest.
- **Treating a missing dependency as an ordering edge.** Wrong: waiting forever for `ghost`. Right: ignore unknown names when ordering, and report `missing dependency` as the status.
- **Running a plugin whose requirement failed.** Wrong: calling `webcam` after `tides` failed. Right: keep a `failed` set and skip dependents with the reason.

# Common Mistakes

- **Treating day-of-month and day-of-week as AND.** Wrong: `d_ok && w_ok` always. With `0 3 1 * 0` that skips every Sunday that is not the first. Right: OR when neither field starts with `*`.
- **Forgetting that `7` is Sunday.** Wrong: rejecting `7` or never matching it. Right: allow 0-7 and copy `dows[7]` to `dows[0]`.
- **A step that starts at zero.** Wrong: `10-50/20` as minutes 0, 20, 40. Right: the step runs from the range start: 10, 30, 50.
- **Leaving `# runs 25m` in the command.** Wrong: the job name becomes `backup-db#`. Right: strip the comment with `match()` before splitting the fields.
- **Comparing overlaps by start times only.** Wrong: two jobs 10 minutes apart look separate even if the first runs for 25. Right: mark every minute each run occupies.
- **Sorting rows as text.** Wrong: `9 shared minutes` sorts after `25`. Right: put a numeric key in front, `100000 - minutes`, and `sort -n`.

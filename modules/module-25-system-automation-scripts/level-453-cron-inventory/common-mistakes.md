# Common Mistakes

- **Splitting on single spaces.** `cut -d' ' -f1-5` breaks when a file uses tabs or two spaces between fields.
  - Right: `read -r m h dom mon dow command <<< "$line"`
- **Treating `MAILTO=...` as a job.** It has fields and an equals sign, but it is a setting.
  - Right: skip lines matching `^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=`.
- **Forgetting `@reboot`.** With five-field parsing the first five words become the schedule, swallowing part of the command.
  - Right: test `[[ $first == @* ]]` before splitting.
- **Losing the last line.** A crontab whose final line has no newline is skipped by a plain `while read`.
  - Right: `while IFS= read -r line || [[ -n $line ]]`
- **Hard-coded column widths in two places.** Header and rows drift out of line when someone edits one format string.
  - Right: one `row()` function with the single `printf`.

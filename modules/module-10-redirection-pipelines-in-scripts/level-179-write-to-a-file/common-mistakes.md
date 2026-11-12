# Common Mistakes

- **Putting the redirect before the thing you meant to capture.** The target is always a file, never a command.
  - Wrong: `> report.txt tide-report "$host"` works but reads oddly and is easy to misplace; `report.txt > tide-report` tries to run report.txt
  - Right: `tide-report "$host" > report.txt`
- **Expecting `>` to keep old data.** Each run empties the file first.
  - Wrong: running the script for two hosts and hoping both are in report.txt
  - Right: use `>>` when you want a growing file (next level)
- **Forgetting the tool may still print to the screen.** `>` only moves standard output.
  - Symptom: error lines still show on screen while the file looks fine; those are on stderr, which has its own operator
- **Writing the file name with a space or an unquoted variable.**
  - Wrong: `tide-report "$host" > $dir/report.txt` when `$dir` has a space
  - Right: `tide-report "$host" > "$dir/report.txt"`

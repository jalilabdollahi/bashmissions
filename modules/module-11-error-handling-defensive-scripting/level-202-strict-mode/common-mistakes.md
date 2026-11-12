# Common Mistakes

- **Splitting the flags wrongly.** Wrong: `set -euopipefail`, `set -e -u -pipefail`. Right: `set -euo pipefail` or the long form `set -e; set -u; set -o pipefail`.
- **Starting the script with a command before it.** Wrong: `mkdir -p "$BACKUP_DIR/$1"` on line 2 and `set -euo pipefail` on line 3: the mkdir ran unprotected. Right: strict mode is the first command.
- **Reading `$1` when no argument was given.** Under `-u`, `site=$1` aborts with "unbound variable". Right for optional arguments: `site=${1:-}` and check it yourself.
- **Expecting a friendly message.** Strict mode stops the script but says nothing about what to do. Bash's "unbound variable" is for developers; user-facing scripts also need their own messages (a later level).
- **Running the report in the middle.** Putting `echo "archived"` before the copy prints a success message for a script that is about to fail. Report last.

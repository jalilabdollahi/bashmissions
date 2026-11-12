# Common Mistakes

- **Forgetting `;;` at the end of a branch.** Bash reports a syntax error near the next pattern.
  - Wrong: `start) echo "starting"` followed by `stop)` with no terminator
  - Right: `start) echo "starting" ;;`
- **Putting `*)` first.** It matches everything, so the specific branches below it never run.
  - Wrong: `case $a in *) echo "?" ;; start) ... esac`
  - Right: put `*)` last
- **Writing the pattern like a test.** A branch is a bare pattern followed by `)`, not a `[[ ]]` expression.
  - Wrong: `[[ $action == start ]])`
  - Right: `start)`
- **Reading `$1` unprotected under `set -u`.** With no argument the script dies before `case` runs, so the usage message never appears.
  - Wrong: `case "$1" in`
  - Right: `case "${1:-}" in`
- **Expecting case-insensitive matching.** `START` is a different word from `start` and falls to `*)`.
  - Wrong: assuming `./solution.sh START` starts the service
  - Right: lowercase the word first (`${action,,}`) if you want to accept both

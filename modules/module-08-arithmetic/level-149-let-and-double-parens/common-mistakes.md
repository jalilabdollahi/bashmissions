# Common Mistakes

- **Unquoted spaces after `let`.** Each word becomes a separate argument.
  - Wrong: `let free = total - used` fails with "let: = : syntax error"
  - Right: `let "free = total - used"` or `let free=total-used`
- **Reading `$?` too late.** Any command in between replaces it.
  - Wrong: `let "free = total - used"; echo "free=$free"; echo "status=$?"` reports the echo's status
  - Right: `let "free = total - used"; st=$?` first, echo later
- **Believing status 1 means the sum went wrong.** It only means the result was zero.
  - Wrong: `if ! let "free = total - used"; then echo "error"; fi` reports an error on a full volume
  - Right: do not use the status of an assignment as an error check
- **`set -e` killing the script on a zero result.**
  - Wrong: `set -e` and `(( used_pct = used * 100 / total ))` when used is 0
  - Right: drop `-e`, or use `used_pct=$(( used * 100 / total ))`

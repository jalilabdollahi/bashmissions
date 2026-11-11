# Common Mistakes

- **Reading `$?` after something else ran.** Any command overwrites it.
  - Wrong: `wait "$pid"; echo "waiting done"; echo "status $?"` reports the status of the first echo.
  - Right: `wait "$pid" || status=$?` or `wait "$pid"; status=$?` straight away.
- **A bare `wait` when you need a status.** It returns 0 once everything is done and tells you nothing about one job.
  - Right: `wait "$pid"`.
- **Letting `set -e` kill the script at the wait.** The verdict is never printed.
  - Wrong: `wait "$pid"` on its own line with `set -e` on.
  - Right: `status=0; wait "$pid" || status=$?`.
- **Using the wrong PID.** `$$` is your own script, and `$!` changes whenever another job starts.
  - Right: `pid=$!` on the line right after the `&`.
- **Starting the check in the foreground.** `integrity-check "$server"` without `&` blocks, so there is nothing to wait for and nothing ran "meanwhile".

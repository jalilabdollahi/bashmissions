# Common Mistakes

- **Treating "curl exited 0" as "alert delivered".** Without `--fail` curl exits 0 even for a 500 response. Read the status code (`-w '%{http_code}'`) and check for 2xx.
- **Escaping in the wrong order.** Wrong: escaping quotes first and then backslashes turns `\"` into `\\"`, which ends the string. Right: backslashes first, then quotes.
- **Printing the response body into your output.** Symptom: `{"ok":true}` glued in front of the status, so `[[ $status == 2?? ]]` never matches. Add `-o /dev/null`.
- **No timeout.** Wrong: a script that waits forever on a dead webhook blocks the very watchdog calling it. Right: `--max-time 5`.
- **Letting `set -e` hide the 000 case.** Wrong: `status=$(curl ...)` aborts silently when curl cannot connect. Right: add `|| true` and report `alert failed (000)` yourself.

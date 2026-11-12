# Common Mistakes

- **Letting `set -e` end the script on the guarded command.** `"$@"` on its own line exits the whole script on failure, before the failure is recorded. Use `"$@" || status=$?`.
- **Forgetting the half-open case in the file.** If a previous probe crashed, the file says `half-open`. A script that only knows `closed` and `open` will treat it as corrupt or ignore the cooldown. Handle it as "probe now".
- **Writing the state in place.** `printf ... > "$state_file"` truncates first; a crash or a concurrent reader sees an empty file. Write a temp file and `mv -f` it.
- **Returning your own status instead of the command's.** Callers need to know *why* the call failed. Skip-because-open gets 75, everything else keeps the command's exit code.
- **Counting failures that were not consecutive.** A success must reset `failures` to 0, otherwise three failures spread over a week open the circuit.

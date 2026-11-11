# Common Mistakes

- **Trusting the exit status without `--fail`.** `curl -s URL` exits 0 on a 500 page, so `if curl ...; then` believes it worked.
  - Right: `curl -sS --fail URL`
- **`-s` without `-S`.** The failure is silent: exit 22 and no clue why.
  - Right: `-sS`, or print your own message from the status.
- **Letting `set -e` swallow the status.** `body=$(curl --fail ...)` ends the script before you can look at `$?`.
  - Right: `rc=0; body=$(curl --fail ...) || rc=$?`
- **Reading `$?` too late.** Any command between the failure and `echo $?` overwrites it.
  - Wrong: `curl ...; echo "x"; echo $?`
  - Right: save it immediately, `rc=$?`
- **Lumping 22 with network errors.** "The server refused" and "I could not reach the server" need different reactions (do not retry the first); check the number.

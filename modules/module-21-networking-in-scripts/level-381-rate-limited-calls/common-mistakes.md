# Common Mistakes

- **Sleeping after every request.** One request per second is half the allowed speed, and a one-ID run waits for nothing.
  - Right: pause only when `sent % 2 == 0`.
- **Sleeping after the last request.** The script ends a second late for no reason.
  - Right: also test `remaining > 0`.
- **Not counting failed requests.** `continue` on an error skips the counter and the pause, so a run of 404s exceeds the limit.
  - Right: count and pace in the same place for success and failure.
- **`set -e` aborting on the first 404.** `body=$(curl --fail ...)` as a plain statement ends the run.
  - Right: use it as an `if` condition.
- **Counting from the wrong variable.** Using `$#` inside the loop never changes; keep your own `remaining` and decrement it.

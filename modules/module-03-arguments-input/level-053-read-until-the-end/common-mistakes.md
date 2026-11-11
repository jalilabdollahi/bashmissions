# Common Mistakes

- **Not initialising the counters.** Without `total=0`, empty input prints
  `total=` and the first `$(( total + cost ))` relies on an unset variable (an
  error under `set -u`). Right: `total=0` before the loop.
- **Dropping the last line.** `while read -r name cost; do` skips a final line
  that lacks a newline. Right: `while read -r name cost || [[ -n $cost ]]; do`.
- **Piping into the loop and losing the totals.** `cat data | while read ...`
  updates variables in a subshell, so after `done` they are back to 0. Redirect
  with `< file` instead, or read stdin directly.
- **Using `for line in $(cat)`.** That splits on every space, not on lines, so
  `usb-cable 12` becomes two items. Use `while read -r`.

# Common Mistakes

- **Mixing up `-z` and `-n`.** `-z` is true for EMPTY, `-n` is true for NOT empty. Say them aloud ("zero", "non-zero") when in doubt.
  - Wrong: `if [[ -n $name ]]; then echo "error: customer name required" >&2` (errors when the name exists)
  - Right: `if [[ -z $name ]]; then ...error...`
- **Reading `$1` bare under `set -u`.** A missing argument kills the script with "unbound variable" instead of your friendly message.
  - Wrong: `name="$1"` when called with no arguments
  - Right: `name="${1:-}"`
- **Comparing with an empty string by hand.** It works, but hides the intent.
  - Wrong: `[[ $name == "" ]]`
  - Right: `[[ -z $name ]]`
- **Forgetting that a space is not empty.** `" "` has length 1, so `-z` is false.
  - Wrong: assuming `./solution.sh " "` is rejected
  - Right: trim first if blanks should count as empty

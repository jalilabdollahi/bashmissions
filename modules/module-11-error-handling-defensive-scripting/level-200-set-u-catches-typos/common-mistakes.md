# Common Mistakes

- **Using `$@` or `$1` carelessly.** Under `set -u`, `echo "$1"` aborts when no argument was given. Right: `${1:-}` when it is optional, or check `$#` first.
- **Thinking `:-` changes the variable.** `${TAG:-latest}` only substitutes in that expansion; `$TAG` is still unset afterwards. To store it: `TAG=${TAG:-latest}`.
- **Putting `set -u` too late.** Wrong: the typo'd line runs before `set -u` on line 20. Right: the first lines of the script.
- **Assuming empty means unset.** `DEPLOY_ROOT=""` passes `set -u`, and the path becomes `/releases/...`. Right: `${DEPLOY_ROOT:?DEPLOY_ROOT is empty}` also rejects empty values.
- **Checking with `[ -z $VAR ]`.** Under `set -u` this dies when VAR is unset. Right: `[[ -z ${VAR:-} ]]`.

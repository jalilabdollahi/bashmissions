# Common Mistakes

- **Letting `set -e` kill the read.** `read -r code` with no stdin exits the
  script silently with status 1, before your check. Right: `read -r code || true`.
- **Leaving out the starting value.** If `code` was never set, `[[ -z $code ]]`
  under `set -u` stops with `unbound variable`. Initialise it: `code=""`.
- **Writing `-z` without `[[ ]]` around the variable.** `[ -z $code ]` breaks if
  the value contains spaces, and prints nothing useful when empty. Use
  `[[ -z $code ]]`.
- **Using `-n` and forgetting to flip the logic.** `[[ -n $code ]] && { error }`
  refuses every *good* answer. `-z` means empty, `-n` means not empty.

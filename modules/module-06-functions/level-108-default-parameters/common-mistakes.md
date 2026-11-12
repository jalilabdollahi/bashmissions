# Common Mistakes

- **Using `$1` bare under `set -u`.** `local days=$1` with no argument aborts with
  "unbound variable". Right: `local days=${1:-30}`.
- **Forgetting the colon.** `${1-30}` only applies when `$1` is unset; an explicit
  empty argument `""` gives an empty value. Right: `${1:-30}`.
- **Putting the default in the wrong place.** `${30:-1}` means "parameter number 30,
  or 1". The name goes left of `:-`, the default on the right.
- **Calling without forwarding.** `retention_line` alone ignores the script's
  arguments; use `retention_line "$@"`.
- **Defaults that hide typos.** Defaults are for optional things. A required value
  silently replaced by a guess is a bug waiting to happen (see the next level).

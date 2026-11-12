# Common Mistakes

- **Searching all the way to `/`.** Wrong: `while [[ $dir != / ]]` reads a `.lanternrc` planted in a parent that is not yours. Right: stop at the given root, `[[ $dir == "$root" ]] && break`.
- **Comparing the typed strings.** Wrong: `work/apps/../apps/web` never equals `work/apps/web`, so the root test never fires. Right: `start=$(cd "$1" && pwd -P)` first.
- **Forgetting to search the root itself.** Wrong: moving to the parent before testing skips the root's file. Right: test the file, then check for the root, then climb.
- **Testing with `-e`.** Wrong: `[[ -e $dir/.lanternrc ]]` accepts a directory of that name. Right: `[[ -f ... ]]`.
- **Letting `cd` failure kill the script silently.** Wrong: `start=$(cd "$1" && pwd -P)` under `set -e` exits with no message. Right: add `|| { echo "not a directory: $1" >&2; exit 2; }`.

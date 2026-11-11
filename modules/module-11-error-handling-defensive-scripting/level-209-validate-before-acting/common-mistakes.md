# Common Mistakes

- **Exiting at the first bad input.** Wrong: `[[ -f $f ]] || { echo "missing: $f" >&2; exit 1; }` inside the checking loop reports only one problem per run. Right: count the bad ones, report all, exit after the loop.
- **Mixing the two phases.** Wrong: a single loop that validates and then moves each file. Right: two loops, the second starting only after the check has passed.
- **Creating the destination first.** Wrong: `mkdir -p archive` before validating leaves an empty folder after a failed run. Right: create it in phase two.
- **Unquoted names.** `for f in $@` splits `price list.txt` into two words. Right: `for f in "$@"`.
- **Testing with `-e`.** `[[ -e reports ]]` accepts a directory, and `mv` would then move the folder. Right: `-f` for regular files, as the objective demands.

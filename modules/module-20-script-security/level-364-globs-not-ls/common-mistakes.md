# Common Mistakes

- **Looping over ls output.** Wrong: `for f in $(ls "$dir"/*.log)` splits `Harbour Bakery.log` into two items. Right: `for f in "$dir"/*.log`.
- **Quoting the star.** Wrong: `for f in "$dir/*.log"` is one literal word; the glob never expands. Right: quote the variable, leave the `*` outside quotes.
- **Forgetting nullglob.** Wrong: an empty folder runs the body once with `f="logs/*.log"`. Right: `shopt -s nullglob` before the loop, or test `[[ -e $f ]]`.
- **Assuming matches are files.** Wrong: `head "$f"` on a folder called `old.log` prints an error. Right: `[[ -f $f ]] || continue`.
- **`read` without `IFS=` and `-r`.** Wrong: `read first < file` strips leading spaces and eats backslashes. Right: `IFS= read -r first < file`.

# Common Mistakes

- **Splitting ls output.** Wrong: `for f in $(ls "$dir")` breaks on spaces and treats `*` in names as wildcards. Right: `for f in "$dir"/*`.
- **Quoting the star.** Wrong: `for f in "$dir/*"` loops once over the literal text. Right: `"$dir"/*`.
- **Forgetting that an empty match stays literal.** Wrong: processing `$f` blindly, which is the string `uploads/*` when the folder is empty. Right: `[ -f "$f" ] || continue` or wrap the body in `if [ -f "$f" ]`.
- **Using the full path as the name.** Wrong: printing `$f` gives `uploads/a.txt`. Right: `${f##*/}` for the base name.
- **Letting a dash-leading name become an option.** Because the glob keeps the directory prefix (`uploads/-rf`), commands see a safe path. With `cd` and `*` you would hit `wc -c -rf`; use `./*` there.

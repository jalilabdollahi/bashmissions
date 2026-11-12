# Common Mistakes

- **Quoting the glob itself.** Wrong: `for f in "$1/*.txt"` loops once over the literal text `inbox/*.txt`. Right: `"$1"/*.txt`.
- **Quoting only some uses.** Wrong: `[ -e "$f" ] && cp $f archive/` still breaks on spaces. Right: every use is `"$f"`.
- **Quoting the destination half.** Wrong: `cp "$f" archive/$name`; a space in `$name` splits the destination. Right: `"archive/$name"`.
- **Trusting `echo $name` to show the problem.** `echo` joins words with single spaces, so a broken name can look correct in output while being wrong in the filesystem. Check with `ls` afterwards.
- **Forgetting the unmatched glob.** Wrong: assuming the loop body never runs when there are no .txt files; it runs once with the literal pattern. Right: test `[ -e "$f" ]`.

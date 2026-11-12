# Common Mistakes

- **Forgetting that a glob with no match stays literal.** The loop then tries to rename a file called `*.jpeg`.
  - Wrong: `for f in uploads/*.jpeg; do mv "$f" ...` with no jpeg files, no `nullglob`
  - Right: `shopt -s nullglob` before the loop (or test `[[ -f $f ]]`)
- **Using `#` when you mean `%`.** `#` trims the start of the string, so nothing happens to the extension.
  - Wrong: `new="${f#.jpeg}.jpg"` gives `uploads/cover.jpeg.jpg`
  - Right: `new="${f%.jpeg}.jpg"`
- **Overwriting by accident.** If the new name exists, `mv` replaces it without a word.
  - Wrong: `mv "$f" "${f%.htm}.html"`
  - Right: `[[ -e $target ]] && continue` (after reporting), then `mv`
- **Using `${f%.*}` blindly.** It cuts the last extension whatever it is, so `a.tar.gz` and `a.txt` are treated alike.
  - Wrong: `new="${f%.*}.md"` when only `.txt` files should change
  - Right: match the extension in the glob, and trim exactly that one

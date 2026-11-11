# Common Mistakes

- **Global `indent`.** Without `local`, each deeper call lengthens the same
  variable, and files after a folder are indented too far. Right: `local indent=$2`.
- **Empty folders print `dir/*`.** The glob stays literal when nothing matches. Skip
  it with `[[ -e $entry ]] || continue`.
- **Printing the full path.** `echo "$entry"` shows `site/css/main.css` at every
  level. Right: `${entry##*/}` for the name only.
- **Recursing on files.** Calling `walk` on a file loops over `file/*` (nothing) and
  hides a bug. Guard with `[[ -d $entry ]]`.
- **Unquoted paths.** `for e in $dir/*` splits `tide tables` into two words. Right:
  `"$dir"/*`.

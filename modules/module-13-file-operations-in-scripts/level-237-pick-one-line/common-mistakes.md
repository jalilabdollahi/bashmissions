# Common Mistakes

- **Leaving out `-n`.** sed then prints the whole file and your line a second time.
  - Wrong: `sed "${day}p" "$rota"`
  - Right: `sed -n "${day}p" "$rota"`
- **Single quotes around a variable.** The shell does not expand it, sed gets the text `${day}p` and complains.
  - Wrong: `sed -n '${day}p' "$rota"` (in sed, `$` even means "last line")
  - Right: `sed -n "${day}p" "$rota"`
- **Not validating the number.** An argument like `3;d` or `monday` becomes part of the sed program.
  - Wrong: `sed -n "${2}p" "$1"` with unchecked input
  - Right: `[[ $2 =~ ^[1-9][0-9]*$ ]] || exit 2` first
- **Expecting an error for a too-big line number.** sed just prints nothing and exits 0.
  - Wrong: assuming `sed -n '99p' short.txt || echo missing` will print "missing"
  - Right: capture the output and test `[[ -z $name ]]`

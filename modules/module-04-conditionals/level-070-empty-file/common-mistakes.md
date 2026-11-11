# Common Mistakes

- **Confusing `-s` with `-e`.** `-e` is true for an empty file; `-s` is not.
  - Wrong: `if [[ -e $file ]]; then echo "report ok"` (accepts the 0-byte file)
  - Right: `if [[ -s $file ]]; then echo "report ok"`
- **Thinking `-s` means "symbolic link" or "socket".** Those are `-L` and `-S`. Lowercase `-s` is about Size.
  - Wrong: `[[ -s $file ]]` expected to be true for an empty link target
  - Right: remember "has Size"
- **Writing `wc -l "$file"` and getting the name in the output.** The line becomes `3 revenue.csv`.
  - Wrong: `lines=$(wc -l "$file")`
  - Right: `lines=$(( $(wc -l < "$file") ))`
- **Expecting `-s` to see whitespace-only files as empty.** A file with one newline has size 1.
  - Wrong: assuming `printf '\n' > f` makes `-s f` false
  - Right: use `grep -q '[^[:space:]]' "$file"` when blank content must also fail

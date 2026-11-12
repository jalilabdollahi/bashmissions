# Common Mistakes

- **Asking `-e` first.** It is true for both files and directories, so the specific branches never run.
  - Wrong: `if [[ -e $path ]]; then echo "regular file"; elif [[ -d $path ]]; ...`
  - Right: test `-f` and `-d` first and let `-e` catch the rest
- **Using `-f` to mean "exists".** A directory is not a regular file, so `-f` is false for it.
  - Wrong: `if [[ -f $dir ]]; then echo "found"` (false for a folder)
  - Right: `if [[ -e $dir ]]` for "anything", `-d` for a folder
- **Forgetting that spaces split words outside `[[ ]]`.** With the older `[ ]` an unquoted path with a space breaks.
  - Wrong: `[ -f $path ]` with `old reports/q1.csv`
  - Right: `[[ -f $path ]]` or `[ -f "$path" ]`
- **Putting a space-less test.** `[[ -f$path ]]` is read as one word.
  - Wrong: `[[ -f$path ]]`
  - Right: `[[ -f $path ]]`

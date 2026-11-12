# Common Mistakes

- **A single operator character.** `${mac^}` changes only the FIRST letter and
  `${mac,}` likewise. For the whole value, double it: `^^` and `,,`.
- **Expecting the variable to change.** After `echo "${mac^^}"` the variable `mac`
  still has its original case. Assign it back with `mac=${mac^^}` when needed.
- **Swapping the symbols.** `${mac,,}` is lowercase, not uppercase. Caret = up.
- **Using it in old Bash.** On macOS `/bin/bash` is 3.2 and these operators fail
  with "bad substitution". Check `bash --version` (Bash 4+ is required).

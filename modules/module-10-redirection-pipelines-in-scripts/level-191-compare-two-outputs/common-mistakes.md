# Common Mistakes

- **Putting a space between `<` and `(`.** Then it is a redirection followed by a subshell.
  - Wrong: `diff < (pkg-list a) < (pkg-list b)`
  - Right: `diff <(pkg-list a) <(pkg-list b)`
- **Forgetting to sort.** The same packages in a different order show up as differences.
  - Wrong: `diff <(pkg-list "$a") <(pkg-list "$b")`
  - Right: `diff <(pkg-list "$a" | sort) <(pkg-list "$b" | sort)`
- **Reading the file name twice.** A process substitution can be read once only.
  - Wrong: `f=<(pkg-list a)` (assigns the text "<(pkg-list a)" and breaks)
  - Right: use `<(...)` directly where you need it
- **Running the script with `sh`.** Process substitution is Bash-only.
  - Symptom: `syntax error near unexpected token '('`
  - Right: `bash solution.sh` and a `#!/usr/bin/env bash` first line

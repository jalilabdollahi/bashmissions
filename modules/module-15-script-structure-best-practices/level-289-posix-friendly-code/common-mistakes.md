# Common Mistakes

- **Calling it sh but writing bash.** Wrong: `#!/bin/sh` with `[[ ]]` works on a Mac (bash in disguise) and fails on Debian. Right: test with `dash script.sh` or `sh script.sh` on a system where sh is not bash.
- **Using `==` in single brackets.** Wrong: `[ "$a" == "$b" ]` is "unexpected operator" in dash. Right: `[ "$a" = "$b" ]`.
- **Forgetting quotes in `[ ]`.** Wrong: `[ -e $path ]` with a space in the name gives "too many arguments". Right: `[ -e "$path" ]`. (Inside `[[ ]]` you got away with it; here you do not.)
- **Keeping `((n++))`.** Wrong: it is a syntax error in dash. Right: `n=$((n + 1))`.
- **Using `echo -e` or `echo -n`.** Behaviour differs between shells. Right: `printf`.

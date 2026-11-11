# Common Mistakes

- **Leaving strict mode at the top of a library.** Wrong: `set -e` on line 2 means `source lib.sh` turns errexit on in the caller, which then dies on its first harmless failure. Right: set options inside the `if` guard, or let the caller decide.
- **Comparing the wrong things.** Wrong: `[[ $0 == solution.sh ]]` breaks when the script is called as `./solution.sh` or by a full path. Right: `[[ ${BASH_SOURCE[0]} == "$0" ]]`.
- **Using `exit` in library code.** Wrong: `exit 2` inside a function that a sourcing shell calls ends the caller. Prefer `return`, and keep `exit` inside `main` or the guard.
- **Forgetting the quotes.** Wrong: `[[ ${BASH_SOURCE[0]} == $0 ]]` treats the right side as a pattern. Right: `"$0"`.
- **Polluting the caller's variables.** Wrong: a function assigning `s=...` without `local`; the sourcing script's `s` changes. Right: `local s`.

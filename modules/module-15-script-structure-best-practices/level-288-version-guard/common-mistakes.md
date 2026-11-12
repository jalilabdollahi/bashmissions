# Common Mistakes

- **Comparing as text.** Wrong: `[[ $BASH_VERSION > 4.4 ]]` is a string comparison and says 10.0 is older than 9.0. Right: compare `${BASH_VERSINFO[0]}` and `[1]` with `(( ))`.
- **Checking only the minor.** Wrong: `(( BASH_VERSINFO[1] >= 4 ))` rejects bash 5.0 because 0 is below 4. Right: major greater, or major equal and minor at least.
- **Forgetting the minor default.** Wrong: `need_minor=${BASH_REMATCH[3]}` is unset for input `5`, and `set -u` aborts. Right: `${BASH_REMATCH[3]:-0}`.
- **Octal surprises.** Wrong: `(( 08 > 7 ))` is an error because 08 is not valid octal. Right: `10#08`.
- **Putting the guard after the new syntax.** Wrong: a function using `declare -A` at the top, then the check below it: the old bash chokes first. Right: guard first, features after.

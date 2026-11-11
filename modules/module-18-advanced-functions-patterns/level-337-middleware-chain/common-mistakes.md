# Common Mistakes

- **Reading with plain `read`.** Wrong: `while read -r line` strips leading and trailing spaces, so `trim` has nothing to do and "no steps" prints `[keep me]`. Right: `while IFS= read -r line`.
- **Starting every step from the original text.** Wrong: `value=$("mw_$step" "$line")` throws away the previous step's work. Right: feed `"$value"` back in.
- **Using `echo` in a step.** Wrong: `echo "$s"` adds a newline (harmless in `$( )`) but breaks on texts like `-n`, and `echo -e` styles vary. Right: `printf '%s' "$s"`.
- **Squeezing only once.** Wrong: `${s//  / }` run a single time turns four spaces into two. Right: loop until no double space remains.
- **Validating while running.** Wrong: finding an unknown step on the first message, after earlier lines were already printed. Right: check the whole chain with `declare -F` before the loop.

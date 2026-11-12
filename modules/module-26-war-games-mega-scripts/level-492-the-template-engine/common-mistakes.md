# Common Mistakes

- **Using `eval` or `bash -c` to expand placeholders.** A value such as `$(rm -rf ~)` or a stray backtick in a template becomes executed code. Peel placeholders apart with parameter expansion and treat everything as text.
- **`sed "s/{{name}}/$value/"`.** A value containing `/` or `&` corrupts the command (and `&` re-inserts the match). Build the output string yourself.
- **Not telling unset from empty.** `[[ -z $val ]]` for "undefined" turns a legitimately empty variable into an error. Test the array with `${vars[$name]+set}`.
- **Leaking loop variables.** After an inner loop, `loop.index` still holds the inner value unless you restore it. The outer loop then prints 2 where it should print 1.
- **Printing while rendering.** If the 40th line has an undefined variable, the first 39 are already on stdout. Collect into a buffer and print at the end.
- **Matching blocks with counters.** Counting `if`/`endif` pairs cannot detect `endfor` closing an `if`. Use a stack and check the kind on top.
- **Stopping at the first structural error.** Listing all of them, in line order, saves the author a dozen rounds of "run, fix, run".

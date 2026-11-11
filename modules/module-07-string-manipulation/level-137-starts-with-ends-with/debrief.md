# Debrief: Starts With, Ends With

You may have wondered whether Bash has `startswith()` and `endswith()`. It does
not need them: `[[ $s == pre* ]]` and `[[ $s == *suf ]]` are the idiom. The reason
it works is that the right side of `==` in double brackets is a pattern, the same
glob syntax you have been using in parameter expansions since the prefix and
suffix levels. A star on one side pins the text to the other end.

Two details matter. First, quoting changes meaning. `[[ $s == "pre*" ]]` compares
against the literal text `pre*`. To test against text held in a variable, quote
only that part: `[[ $s == "$prefix"* ]]`, so special characters in the variable
stay literal but the trailing star stays a wildcard. Second, `[[ ]]` is a Bash
feature, not POSIX `sh`; it avoids the word-splitting traps of `[ ]`, so you
rarely need to quote the left side.

Order of tests is logic, not decoration. Rules that can overlap need an explicit
priority, and the `if/elif` chain provides it. Real filters, routers and
classifiers all work this way: first match wins.

Going further: matching at an end is a special case of matching anywhere. The next
level checks for a substring inside the value.

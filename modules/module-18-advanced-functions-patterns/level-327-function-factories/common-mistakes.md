# Common Mistakes

- **Using eval on unchecked input.** Wrong: `eval "log_$1() { ...; }"` with `$1` = `x;rm -r data`. The second command runs. Right: test `[[ $level =~ ^[a-z]+$ ]]` first and refuse everything else.
- **Expanding `$*` too early.** Wrong: `eval "log_$level() { echo $*; }"` freezes the arguments of the *factory* call into the body. Right: escape it, `\$*`, so the logger expands its own words.
- **Bad quoting inside the string.** A bare `'` in the middle of a double-quoted eval string, or a lost backslash in `\\n`, gives a syntax error that appears at the `eval` line. Print the string with `echo` to see what eval would run.
- **Putting the message into the generated text.** Wrong: building the function body with the message pasted in. Quotes in the message become code. Right: pass data as arguments when calling the function.
- **Forgetting the function does not exist yet.** Calling `log_warn` before `make_logger warn` ran gives "command not found". Create first, call afterwards.

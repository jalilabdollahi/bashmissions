# Common Mistakes

- **Leaving the right side unquoted.** Wrong: `[[ $actual == $expected ]]`. With `expected='a*'`, the actual value `abc` matches and the test passes. Right: `[[ $actual == "$expected" ]]`.
- **Calling `exit` inside the helper.** Wrong: `exit 1` in `assert_eq` ends the whole script at the first failing check. Right: `return 1`, so callers can decide.
- **Printing the failure on stdout.** Wrong: `echo "FAIL ..."` mixes with normal output and can hide in a pipe. Right: `>&2`.
- **Omitting the values from the message.** `FAIL: web port` forces a rerun to see what happened. Show `expected '...' but got '...'`.
- **Testing the numbers with `-eq` when you mean strings.** `[[ 08 -eq 8 ]]` is a number comparison with surprising results (and errors for non-numbers). For text, use `==` with quotes.

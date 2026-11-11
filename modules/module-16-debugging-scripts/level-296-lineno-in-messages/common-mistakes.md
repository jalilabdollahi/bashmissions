# Common Mistakes

- **Typing the number.** Wrong: `echo "error (line 7): ..."`. It is right today and wrong after the next edit. Right: `echo "error (line $LINENO): ..."`.
- **Single quotes around the message.** Wrong: `echo 'error (line $LINENO): ...'` prints the characters `$LINENO`. Right: double quotes so the variable expands.
- **Forgetting `>&2`.** Without it the error lands on stdout and mixes with the real output, and the test for an empty stdout fails.
- **Putting `$LINENO` in a helper function and expecting the caller's line.** `die() { echo "line $LINENO: $1" >&2; }` always reports the line of that echo inside `die`. Pass `$LINENO` in as an argument from the call site: `die "$LINENO" "msg"`.
- **Testing size before existence.** `[[ ! -s $1 ]]` is also true for a missing file, so the "not found" case would be reported as "empty". Check `-e` first.

# Common Mistakes

- **Choosing the next number and then writing with a plain `>`.** Two publishers can both pick #5 and one silently overwrites the other. Create the file under `set -C` (noclobber) and move to the next number when it fails.
- **Moving the cursor before the handler succeeds.** A crash then loses the message. Advance it only after success (or after dead-lettering).
- **Letting a failed message be overtaken.** If the loop `continue`s after a failure, message #3 is delivered before #2 is retried. Stop that subscriber's run instead.
- **Counting retries globally.** A tries file that holds only a count carries the failures of message #2 over to #3. Store the sequence number together with the count.
- **Quoting the pattern in `[[ $topic == "$pattern" ]]`.** Quoted, it is compared literally and `deploy.*` matches nothing. Leave the pattern unquoted for glob matching.
- **Running arbitrary text as a handler.** `eval "$handler ..."` with a handler like `x; cleanup-everything` is a command injection. Validate a single command word and call it as `"$handler" "$topic" ...`.
- **Octal numbers.** `$(( 000008 + 1 ))` is an error. Use `10#`.

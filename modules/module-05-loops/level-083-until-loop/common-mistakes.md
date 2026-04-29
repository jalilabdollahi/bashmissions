# Common Mistakes for until Loop

- Forgetting to update the loop counter or stopping condition.
- Using unquoted `"$@"` incorrectly; use `for arg in "$@"` for arguments with spaces.
- Reading files with `for line in $(cat file)`, which splits on whitespace instead of lines.
- Printing extra debug text that the exact-output validator does not expect.

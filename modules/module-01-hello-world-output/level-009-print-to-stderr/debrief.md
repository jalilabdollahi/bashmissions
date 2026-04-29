# Print to Stderr

This level teaches redirecting output to stderr using `>&2`.

In shell scripts, stdout (fd 1) is for normal output and stderr (fd 2) is for errors and diagnostics. Tools that pipe your script's output only read stdout — stderr goes elsewhere.

Key points:

- `echo "msg" >&2` — sends to stderr, nothing appears on stdout.
- The validator checks that stdout is empty and exit code is 0.

Example run:

```bash
./solution.sh "disk full"
# (stdout is empty; stderr shows: Error: disk full)
```

Using stderr for errors is a Unix convention that makes scripts composable with pipes.

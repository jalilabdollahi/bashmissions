# Suppress Newline

This level teaches `echo -n`, which suppresses the trailing newline that `echo` normally adds.

Key points:

- `echo "Hello"` outputs `Hello\n` (with newline).
- `echo -n "Hello"` outputs `Hello` (no newline).
- This is useful when you want to continue output on the same line or when a trailing newline would break a downstream tool.

Example run:

```bash
./solution.sh alpha beta
# LEVEL 8: Suppress Newline | alpha | beta
```

Note: `printf` is often preferred for portability, but `echo -n` is widely supported in bash scripts.

# Script Exit Code

Every Unix process returns a number when it ends — its **exit status**. By convention `0` means success, and anything from `1` to `255` signals failure. Tools like `make`, `bash &&`, and CI pipelines all key off this number.

In Bash:

- `exit` with no argument exits with the status of the last command.
- `exit 0` forces a clean success.
- `exit 1` (or any nonzero) signals an error.
- The special variable `$?` holds the previous command's status.

```bash
./solution.sh 0   # prints "exit code: 0", returns 0
./solution.sh 1   # prints "exit code: 1", returns 1
echo $?           # 1
```

The script tests above run your solution three times and check both stdout and the returned exit code. You can verify yourself with `echo $?` after a run.

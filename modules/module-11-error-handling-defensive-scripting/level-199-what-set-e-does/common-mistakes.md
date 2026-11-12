# Common Mistakes

- **Bare grep under set -e.** Wrong: `grep -q FATAL "$1"` as a standalone line exits the script on a clean log. Right: `if grep -q FATAL "$1"; then ... fi`.
- **Expecting `a && b` to stop on a failing `a`.** With set -e, `false && echo hi` does not exit, because `a` is tested by the list. Only a failing last command counts, so `echo hi && false` does exit.
- **Counting with `((n++))`.** `n=0; ((n++))` returns status 1 (the old value 0 is "false") and kills the script under set -e. Right: `n=$((n + 1))`.
- **Putting set -e after the dangerous line.** Wrong: `cp ...` on line 3 and `set -e` on line 6 protects nothing above it. Right: second line of the script.
- **Believing set -e survives if-conditions.** Wrong: calling `check_disk` in `if check_disk; then` and expecting it to stop halfway on an inner failure. The inside runs with errexit off.

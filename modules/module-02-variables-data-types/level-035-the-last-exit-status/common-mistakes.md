# Common Mistakes

- **Reading `$?` too late.**
  Wrong: `grep -q ...; echo "checking"; rc=$?` saves the status of the echo, always 0.
  Right: `grep -q ...` then `rc=$?` on the very next line.
- **Reversed meaning.**
  `0` is success, so for `grep -q` it means *found*. Printing `active=0` for an active server is correct, not a bug.
- **Using grep without `-x`.**
  Wrong: `grep -q dor fixtures/active.txt` succeeds because `dory` contains `dor`.
  Right: `grep -q -x -F dor ...` demands a whole-line match.
- **Quoting the number.** `exit "$active_rc"` is fine, but `exit active_rc` (no dollar) gives `numeric argument required`.

# Common Mistakes

- **Guessable "unique" names.** Wrong: `work="$TMPDIR/report.$$"`. PIDs are small numbers an attacker can try. Right: `mktemp "$TMPDIR/report.XXXXXX"`.
- **Checking, then creating.** Wrong: `[[ -e $f ]] || touch "$f"` leaves a gap between the test and the touch. Right: one atomic step with mktemp.
- **Double quotes in the trap.** Wrong: `trap "rm -f $work" EXIT` expands `$work` now, and breaks if the path has spaces. Right: `trap 'rm -f "$work"' EXIT`.
- **Setting the trap too late.** Wrong: creating the file, doing risky work, then installing the trap at the bottom; a failure in between leaks the file. Right: trap on the line right after mktemp.
- **Template without the X characters.** Wrong: `mktemp "$TMPDIR/report"` is not accepted by every mktemp. Right: end the template with at least six `X`.

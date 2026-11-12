# Common Mistakes

- **Quoting the glob.** A quoted star is just a star.
  Wrong: `[[ $code == "TEST-*" ]]` matches only the literal text `TEST-*`
  Right: `[[ $code == TEST-* ]]`
- **Using `break` where you mean `continue`.** The first test account would stop the whole billing run.
  Wrong: `break` inside the TEST- branch (everything after the first test account is lost)
  Right: `continue`
- **Placing the work before the guard.** Code above the `continue` still runs for the skipped item.
  Wrong: `echo "billing $code"` first, then the if/continue
  Right: guard first, work after
- **Forgetting the dash in the pattern.** `TEST*` would also skip real codes like `TESTING-HQ`.

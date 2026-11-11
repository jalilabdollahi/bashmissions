# Common Mistakes

- **Doubling before printing the first attempt.** The schedule starts at twice the base.
  Wrong: `delay=$(( delay * 2 ))` at the top of the loop body
  Right: print first, double at the end of the body
- **Capping after doubling only.** If BASE is already above CAP the first line breaks the rule.
  Right: compare with the cap before you print each delay
- **Adding to the total before the cap.** The sum then counts waits that never happen.
  Right: cap, print, then add
- **`${total}s` written as `$totals`.** Without braces Bash looks for a variable named `totals`.
  Wrong: `echo "total wait: $totals"` prints an empty value
  Right: `echo "total wait: ${total}s"`
- **Calling `sleep` while testing.** A schedule of 1+2+4+8+16 seconds is already half a minute of nothing.

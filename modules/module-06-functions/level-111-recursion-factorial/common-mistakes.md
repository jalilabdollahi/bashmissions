# Common Mistakes

- **No base case.** `factorial() { echo $(( $1 * $(factorial $(( $1 - 1 ))) )); }`
  never stops. Right: return 1 when `n <= 1`.
- **Wrong base case.** Stopping at `n == 1` only makes `factorial 0` recurse into
  -1, -2... Use `n <= 1`.
- **Forgetting `local`.** With a global `n`, the inner call changes the value the
  outer call multiplies by, and the result is wrong.
- **Not capturing the answer.** A bare `factorial $(( n - 1 ))` prints the smaller
  result to the screen instead of handing it to you. Right: `smaller=$(factorial ...)`.
- **Going past 20.** 21! overflows 64-bit integers and Bash silently wraps to a
  wrong (even negative) number.

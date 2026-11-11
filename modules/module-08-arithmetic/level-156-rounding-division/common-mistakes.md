# Common Mistakes

- **Assuming `/` rounds to the nearest.** It always rounds down.
  - Wrong: `$(( 7 / 2 ))` expected to be 4
  - Right: `$(( (7 + 2 / 2) / 2 ))` is 4
- **Adding the whole divisor for the ceiling.** That overshoots whenever the division is exact.
  - Wrong: `$(( (8 + 4) / 4 ))` is 3, but 8 / 4 is exactly 2
  - Right: `$(( (8 + 4 - 1) / 4 ))` is 2
- **Rounding each share and expecting the sum to match.** Three shares of 3.33 rounded to 3 add up to 9, not 10; decide who absorbs the leftover cent.
  - Wrong: assuming `nearest * parts` equals the amount
  - Right: compute the remainder (`amount - floor * parts`) and hand it out explicitly
- **Using these formulas on negative amounts.** Integer division truncates toward zero.
  - Wrong: `$(( (-7 + 1) / 2 ))` gives -3 where school rounding of -3.5 would give -3 or -4 depending on the rule
  - Right: work on the absolute value and put the sign back

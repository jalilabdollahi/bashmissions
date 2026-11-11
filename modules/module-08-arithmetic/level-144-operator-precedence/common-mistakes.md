# Common Mistakes

- **Expecting the sum to happen first because it is written first.**
  - Wrong: `$(( base + gb * rate * servers ))` charges the base fee only once
  - Right: `$(( (base + gb * rate) * servers ))`
- **Parentheses in the wrong place.** They change what is grouped, so check what is inside.
  - Wrong: `$(( (base + gb) * rate ))` multiplies the base fee by the rate too
  - Right: `$(( base + gb * rate ))` for one server
- **Chained subtraction read right to left.** Equal-strength operators go left to right.
  - Wrong: assuming `$(( 10 - 3 - 2 ))` is 9
  - Right: it is 5; write `$(( 10 - (3 - 2) ))` if you want 9
- **Splitting the formula into two `$(( ))` and gluing them in text.**
  - Wrong: `total=$(( base + gb ))$(( rate * servers ))` produces a long string of digits
  - Right: one expression, one pair of `$(( ))`

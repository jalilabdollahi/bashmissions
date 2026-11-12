# Common Mistakes

- **Putting the warning check first.** A 95% disk would be reported as WARNING.
  - Wrong: `if (( used * 100 >= total * 75 )); then echo WARNING; elif ...CRITICAL`
  - Right: test the strictest threshold first
- **Using `[[ ]]` operators inside `(( ))`.**
  - Wrong: `if (( used -ge total ))` is a syntax error
  - Right: `if (( used >= total ))`
- **Single `=` in a condition.** That assigns, and the result is almost always true.
  - Wrong: `if (( used = total ))` sets used and succeeds when total is non-zero
  - Right: `if (( used == total ))`
- **Dividing first and losing the fraction.**
  - Wrong: `(( used / total * 100 >= 90 ))` is 0 for any disk that is not full
  - Right: `(( used * 100 >= total * 90 ))`

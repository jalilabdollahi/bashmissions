# Common Mistakes

- **Putting a space between the operator characters.**
  - Wrong: `(( steady + = add ))` is a syntax error
  - Right: `(( steady += add ))`
- **Using `+=` outside arithmetic.** On a plain string variable it appends text, not numbers.
  - Wrong: `size=100; size+=15` gives `10015`
  - Right: `(( size += 15 ))` gives 115
- **Starting the second scenario from the first one's result.** Both must begin at START; copy it into two variables.
  - Wrong: `doubling=$steady` after the loop started
  - Right: `steady="$start"; doubling="$start"` before it
- **`*=` with the wrong operand.** `*= 2` doubles the current value; `*= month` multiplies by the month number.
  - Wrong: `(( doubling *= doubling ))` squares the size each month
  - Right: `(( doubling *= 2 ))`

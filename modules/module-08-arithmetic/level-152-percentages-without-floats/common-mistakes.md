# Common Mistakes

- **Dividing before multiplying.**
  - Wrong: `$(( used / total * 1000 ))` gives 0 for any partly used disk
  - Right: `$(( used * 1000 / total ))`
- **Scaling by 100 and then expecting a decimal.** You lose the digit you wanted.
  - Wrong: `$(( used * 100 / total ))` gives 33 for 1 of 3
  - Right: scale by 1000 to get tenths
- **Splitting the tenths with the wrong divisor.** The whole part is `/ 10`, the digit is `% 10`.
  - Wrong: `echo "$(( tenths / 100 )).$(( tenths % 100 ))"` for 37.5% prints 3.75
  - Right: `echo "$(( tenths / 10 )).$(( tenths % 10 ))"`
- **Ignoring TOTAL=0.** Bash stops with "division by 0" and a non-zero status.
  - Wrong: no check before the division
  - Right: `if (( total == 0 )); then ... exit 2; fi`

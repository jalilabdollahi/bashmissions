# Common Mistakes

- **Starting min and max at zero.** A list of all-positive numbers then reports a minimum of 0, and all-negative lists a maximum of 0.
  - Wrong: `min=0; max=0` before the loop, then comparisons only
  - Right: set both from the first value read
- **Dividing by count with no data.** An empty input makes `sum / count` fail with "division by 0".
  - Wrong: `echo "avg=$(( sum / count ))"` with count at 0
  - Right: check `count == 0` first and exit 1
- **Comparing numbers as text.** In `[[ ]]`, `<` and `>` compare alphabetically, so 9 is "greater" than 10.
  - Wrong: `if [[ $value > $max ]]`
  - Right: `if (( value > max ))`
- **Skipping the blank-line check.** An empty `value` makes `(( value < min ))` treat it as 0, so a blank line corrupts min or max.
  - Wrong: no `[[ -z $value ]] && continue`
  - Right: skip blank lines at the top of the loop

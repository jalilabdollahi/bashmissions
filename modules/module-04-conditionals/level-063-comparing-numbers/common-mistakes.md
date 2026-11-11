# Common Mistakes

- **Using `>` and `<` inside `[[ ]]` for numbers.** They compare as text (alphabetically), so 9 is "greater" than 70.
  - Wrong: `if [[ $used > 70 ]]; then` (true for 9)
  - Right: `if [[ $used -gt 70 ]]; then`
- **Using `==` for "at least".** Equality only catches the exact value.
  - Wrong: `elif [[ $used == 90 ]]` (misses 91 to 99)
  - Right: `elif [[ $used -ge 90 ]]`
- **Off by one on the boundary.** "70 or more" includes 70.
  - Wrong: `[[ $used -gt 70 ]]` (70 comes out OK)
  - Right: `[[ $used -ge 70 ]]`
- **Putting the broad band first.** `-ge 70` would grab 95 before CRITICAL gets a chance.
  - Wrong: `if [[ $used -ge 70 ]] ... elif [[ $used -ge 90 ]]`
  - Right: test 90 before 70

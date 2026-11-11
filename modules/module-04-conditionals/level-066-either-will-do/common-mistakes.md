# Common Mistakes

- **Leaving out the variable in later comparisons.** Each side of `||` is a whole test.
  - Wrong: `[[ $day == sat || sun ]]` ("sun" alone is a non-empty string, so this is always true)
  - Right: `[[ $day == sat || $day == sun ]]`
- **Using `&&` when the rule says "or".** The weekend rota would apply only on Saturday holidays.
  - Wrong: `[[ $day == sat && $day == sun ]]` (a day cannot be both)
  - Right: `[[ $day == sat || $day == sun ]]`
- **Using a single `|`.** That is a pipe, not "or".
  - Wrong: `[[ $day == sat | $day == sun ]]`
  - Right: `[[ $day == sat || $day == sun ]]`
- **Repeating the echo in three `elif` branches.** It works, but a rule change must then be made in three places.
  - Wrong: `elif [[ $day == sun ]]; then echo "weekend rota..."`
  - Right: one condition with `||`

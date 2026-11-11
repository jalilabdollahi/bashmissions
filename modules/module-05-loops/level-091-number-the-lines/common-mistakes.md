# Common Mistakes

- **Starting at 1 with a zero-based array.** The first day is skipped and the last read is empty.
  Wrong: `for (( i=1; i<=${#people[@]}; i++ ))` with `${people[i]}`
  Right: `for (( i=0; i<${#people[@]}; i++ ))`
- **Forgetting the wrap.** Past the seventh person the day name is empty.
  Wrong: `${days[i]}` for i=8 prints an empty day
  Right: `${days[i % 7]}`
- **Copying arguments without quotes.** `people=($@)` splits "Ollie Park" into two people.
  Right: `people=("$@")`
- **Writing `${people[$i]}` with a missing brace or `$people[i]`.** Without the braces only `$people` (the first element) is expanded, followed by the text `[i]`.
- **Using `<=` for the limit.** `i <= ${#people[@]}` runs one round too many and prints an empty name.

# Common Mistakes

- **Unquoted expansion in the list.** `for a in ${amounts[@]}` splits every element at spaces and expands globs. Right: `for a in "${amounts[@]}"`.
- **Looping over the array name only.** `for a in $amounts` visits only element 0.
- **Expecting the loop variable to change the array.** `amount=0` in the body does not touch `amounts`.
- **Using `[*]` in quotes.** `for a in "${amounts[*]}"` runs the body once, with all values glued into one string.
- **Comparing numbers as strings.** `[[ $amount > 99 ]]` compares text, so "5" is "greater" than "100". Use `(( amount >= 100 ))`.

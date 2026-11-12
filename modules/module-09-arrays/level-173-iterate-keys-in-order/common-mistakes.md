# Common Mistakes

- **Sorting numbers as text.** `sort` puts `10` before `2`. Right: `sort -n`, and `sort -rn` for descending.
- **Printing in map order.** `for u in "${!rack[@]}"` looks fine in a quick test and changes order on another machine. Sort the keys.
- **Splitting on the wrong equals sign.** `${pair%=*}` (one percent) removes only the last `=...`, which for `console cable=blue` leaves `9=console cable`. Use `%%=*` for the key and `#*=` for the value.
- **Sorting the lines instead of the keys.** Printing `"unit: device"` lines and piping them into `sort -n` sorts by whatever text the line begins with and breaks when the format changes. Sort keys, then look up values.
- **Reading keys with `for k in $(... | sort)`.** Keys with spaces split apart. `while IFS= read -r k` keeps them whole.

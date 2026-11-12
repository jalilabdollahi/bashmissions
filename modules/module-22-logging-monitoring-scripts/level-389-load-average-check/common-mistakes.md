# Common Mistakes

- **Comparing decimals as text or integers.** Wrong: `(( l1 > limit ))` with `0.52` stops with a syntax error, and `[[ $l1 > $limit ]]` says `10.00` is smaller than `2` (string order). Right: let awk compare, `awk -v a="$l1" -v b="$limit" 'BEGIN{exit !(a+0 > b+0)}'`.
- **Splitting on spaces only.** Wrong: `read -r a b c <<< "0.52, 0.58, 0.59"` leaves commas on the first two numbers (`0.52,`). Right: `IFS=', ' read -r ...`.
- **Counting from the start of the line.** Wrong: `awk '{print $10}'` works until the uptime is `up 3:04` instead of `up 12 days, 3:04` and every field moves. Right: anchor on the label with `${out##*load average: }`.
- **Setting IFS for the whole script.** Wrong: `IFS=', '` on its own line changes how every later expansion splits. Right: prefix it to one command, `IFS=', ' read ...`.
- **Exiting before the trend.** Symptom: HIGH prints but the trend line never appears. Save the status in a variable and `exit "$status"` last.

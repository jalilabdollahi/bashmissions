# Common Mistakes

- **Comparing numbers as text.** `$3 >= min` where both look like strings decides "9" > "10". Force numbers: `$3 + 0 >= min + 0`.
- **Letting junk count as zero.** `n/a + 0` is 0, so `$3 + 0 >= 0` accepts it. Match the shape first: `$3 ~ /^[0-9]+(\.[0-9]+)?$/`.
- **Splicing shell values into the program.** Wrong: `awk "\$2 == \"$2\""`. A region containing a quote breaks the program (or worse). Right: `awk -v region="$2" '$2 == region'`.
- **Printing the header through the filter.** The header row's gb column is the word `gb`, so it never passes the numeric test and vanishes. Handle line 1 in its own rule.
- **Adding an action by accident.** `$2 == region { }` matches and prints nothing. Leave the action out, or write `{ print }`.

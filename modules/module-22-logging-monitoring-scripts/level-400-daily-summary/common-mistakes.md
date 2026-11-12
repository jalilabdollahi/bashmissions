# Common Mistakes

- **Counting lines from other days.** Wrong: `grep -c ERROR file` counts yesterday's tail too. Filter on the date field first (`$1 == day`).
- **Printing nothing for a zero count.** Wrong: awk's `print level["ERROR"]` prints an empty string when there were no errors. Right: `print level["ERROR"] + 0`.
- **Sorting counts as text.** Wrong: `sort -k2` puts `10` before `9`. Right: `sort -k2,2nr -k1,1` (numeric, reversed, then host name).
- **Trusting file order for first and last.** Wrong: taking the first ERROR line of the first file as the earliest error. Each file has its own order, so compare every time with the current minimum and maximum.
- **Reading every file once per fact.** Wrong: four `grep -c` runs for four numbers, per file. One awk pass collects everything at once.

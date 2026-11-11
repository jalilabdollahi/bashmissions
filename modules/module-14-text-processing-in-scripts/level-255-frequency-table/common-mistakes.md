# Common Mistakes

- **Skipping the first sort.** `cut ... | uniq -c` counts runs, not totals: `/menu /book /menu` gives three groups of one. Right: `cut ... | sort | uniq -c`.
- **Ranking counts as text.** `sort -r` puts `9` above `11`. Use the numeric flag: `sort -rn` or `-k1,1nr`.
- **Comparing the raw uniq -c output.** `"      3 /menu"` on one machine and `"   3 /menu"` on another do not match a test or a `cut -d' ' -f1`. Normalise with `sed 's/^ *//'`.
- **Leaving ties to chance.** `sort -rn` alone orders equal counts by the whole line, which is fragile. Name the tie-breaker with a second key.
- **Counting the wrong column.** In `10.0.0.5 GET /menu 200` the path is field 3; counting field 1 gives requests per client, a different report.

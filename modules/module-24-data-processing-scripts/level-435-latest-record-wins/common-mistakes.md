# Common Mistakes

- **Trusting file order.** Taking the last row per key assumes the file is sorted by time. Compare the `updated` values, not the line numbers.
- **Skipping the key normalisation.** `Theo@NorthPier.example` and `theo@northpier.example` become two customers, and the old plan keeps getting mail. Use `tolower($1)` for the key.
- **Using `>` for the comparison.** On equal timestamps the earlier row stays, which makes the result depend on the order of the file. `>=` makes the later row win consistently.
- **Sorting the whole line.** `sort` on whole lines compares past the first comma, so `a-b@x` and `a@x` come out in an order the key does not justify. Use `sort -t, -k1,1`.
- **Sorting the header with the data.** `... | sort` swallows the header line into the rows. Print it first, separately, then sort only the records.

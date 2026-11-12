# Common Mistakes

- **Converting to epoch seconds.** `date -d "$ts" +%s` per line is slow and not portable (BSD `date` has other flags). Plain text comparison is enough for ISO timestamps.
- **Making the upper bound inclusive.** `$1 <= to` puts a line at exactly `15:30:00Z` into both the 14:00 window and the 15:30 window. Use `<` for the end.
- **Trusting any date format.** `2026-4-1T10:00:00Z` or `04/01/2026` break the "text order is time order" rule. Check the shape and report the others.
- **Using `[ a > b ]` instead of `[[ a > b ]]`.** Single brackets treat `>` as a redirect and create a file called `b`. Use double brackets for string comparison.
- **Sorting out of order data.** The filter keeps file order; it does not sort. If you also need chronological output, pipe the result through `sort`.

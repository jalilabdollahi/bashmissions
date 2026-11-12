# Common Mistakes

- **Expecting numbers to sort as numbers.** `printf '10\n9\n' | sort` prints 10 first. Numeric order needs `-n`, which you meet next.
- **Trusting the locale.** On a machine with a UTF-8 locale, `sort` may order `a A b B`. A script that depends on order should set `LC_ALL=C` or be tested under it.
- **Sorting a file and expecting it to change.** `sort names.txt` only prints; the file is untouched. Wrong: `sort names.txt` and then reading `names.txt` again. Right: `sort names.txt > sorted.txt` (never `> names.txt`, which empties the input before sort reads it).
- **Using -u by habit.** `sort -u` silently drops duplicate lines. Fine for a unique list, wrong when counts or repeated rows matter.
- **Passing lines as arguments.** `sort $(cat list)` splits on spaces and turns lines into file names. Let it read the stream: `sort < list`.

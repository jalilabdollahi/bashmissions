# Common Mistakes

- **Expecting uniq to find non-adjacent duplicates.** `printf 'a\nb\na\n' | uniq` prints all three lines. Only `sort | uniq` (or `sort -u`) removes the second `a`.
- **Sorting a timeline.** Wrong: `sort "$1" | uniq` for a state history; you get DOWN, OK, SLOW. Right: `uniq "$1"`.
- **Invisible differences.** `OK` and `OK ` (with a trailing space) are different lines to `uniq`, so they are not merged. Normalise whitespace first if the data is messy.
- **Writing back to the input.** Wrong: `uniq "$1" > "$1"`. The shell empties the file before `uniq` reads it. Right: write to a new file, then `mv` it.
- **Mixing up -d and -u.** `uniq -d` prints only lines that were repeated and `uniq -u` only lines that were not. Neither is the plain collapse you need here.

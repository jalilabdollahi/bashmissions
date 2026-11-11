# Common Mistakes

- **Using `sort -u`.** It removes duplicates but also reorders everything alphabetically, so "first misbehaved" is lost.
- **Not resetting the flag.** If `seen=0` is set only once before the outer loop, after the first duplicate every later name looks already seen and nothing more is appended.
- **Comparing without quotes.** `[[ $kept == $name ]]` treats `$name` as a pattern; a name such as `*` would match everything.
- **Appending inside the inner loop.** Putting `unique+=("$name")` in the `else` of the comparison appends once per non-matching element, not once per name.
- **Counting repeats by hand and drifting.** Compute `$# - ${#unique[@]}` once at the end instead of incrementing in several places.

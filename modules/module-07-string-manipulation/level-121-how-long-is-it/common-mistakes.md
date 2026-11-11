# Common Mistakes

- **Forgetting the braces.** `$#name` is not the length: `$#` is the number of
  script arguments, followed by the text "name". Right: `${#name}`.
- **Putting the hash in the wrong place.** `${name#}` is a different operator (it
  strips a prefix, a later level). The length hash goes first: `${#name}`.
- **Reaching for wc.** `echo $name | wc -c` counts the newline too, so you get
  length plus one, and unquoted `$name` loses extra spaces. Use `${#name}`.
- **Comparing as text.** `[[ $len > 12 ]]` compares alphabetically, so `9 > 12`
  is true. Use `(( len > 12 ))` or `[[ $len -gt 12 ]]`.

# Common Mistakes

- **Leaving out the subscript.** `${#fleet}` is the length of element 0, not the number of elements.
  Right: `${#fleet[@]}`
- **Counting with `wc`.** `echo "${fleet[@]}" | wc -w` miscounts names that contain spaces. "giant grouper" counts as two. The length expansion counts elements, not words.
- **Using `[*]` and expecting a different number.** In `${#fleet[*]}` the count is the same, but people then write `"${fleet[*]}"` elsewhere and get a single glued string.
- **Treating length as the last index.** Length 3 means indexes 0, 1, 2. `${fleet[${#fleet[@]}]}` is one past the end and expands to nothing.
- **Forgetting to protect the length with an empty-array check.** A length of 0 is normal; code that assumes at least one element, such as `${fleet[-1]}`, fails on an empty array.

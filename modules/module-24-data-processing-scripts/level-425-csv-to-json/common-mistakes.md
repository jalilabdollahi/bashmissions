# Common Mistakes

- **Escaping in the wrong order.** Replacing `"` with `\"` first and then every `\` with `\\` turns `\"` into `\\"`, which closes the string early. Walk the characters once instead.
  Wrong: `gsub(/"/, "\\\"", s); gsub(/\\/, "\\\\", s)`
  Right: a `substr` loop that handles each character exactly once.
- **Quoting every value.** `"price":"12.5"` is valid JSON but the number is now a string, and `"note":""` hides a missing value. Use bare numbers and `null`.
- **Treating `007` as a number.** JSON forbids leading zeros; many parsers reject the document or turn it into 7. Use the grammar `(0|[1-9][0-9]*)`.
- **A trailing comma after the last object.** JSON does not allow it. Print each object one step late, or print the comma before every object except the first.
- **Forgetting the empty case.** A header-only file must still produce valid JSON: `[]`, not an empty output and not `[` with no `]`.

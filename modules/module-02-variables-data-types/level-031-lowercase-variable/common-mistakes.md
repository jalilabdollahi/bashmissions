# Common Mistakes for Lowercase Variable

- Misremembering the symbol. Uppercase uses `^` (carets); lowercase uses `,` (commas). It helps that `^` "points up" and `,` "drops down".

- Swapping single and double comma: `${var,}` only lowercases the first character. Easy mistake when copy-pasting from upper-case examples.

- Bash 3.x doesn't support these. On older macOS, fall back to `echo "$text" | tr '[:upper:]' '[:lower:]'`.

- Forgetting the braces: `echo $text,,` prints the literal commas. The expansion only happens inside `${ }`.

- Comparing without normalising: `[[ "$answer" == "yes" ]]` fails for `Yes` and `YES`. Lowercase first or compare against a pattern: `[[ "$answer" =~ ^[Yy] ]]`.

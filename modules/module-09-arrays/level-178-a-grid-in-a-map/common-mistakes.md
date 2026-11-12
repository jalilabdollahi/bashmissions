# Common Mistakes

- **Using a plain array.** Without `declare -A`, `grid[$r,$c]` evaluates `$r,$c` as arithmetic (the comma operator), and only the last cell in each row survives.
- **Keys that collide.** `grid[$r$c]` makes (1, 11) and (11, 1) both `111`. Keep a separator in the key: `grid[$r,$c]`.
- **Swapped loop nesting.** With the row loop outside and the column loop inside you simply print the original grid. For the transpose, the column loop is outside.
- **Space before the first cell.** `line+=" ${grid[$r,$c]}"` leaves a leading space. `${line:+ }` adds the separator only when something is already there.
- **Forgetting the last line without a newline.** `while read -r -a cells; do` silently drops it. Add `|| (( ${#cells[@]} > 0 ))`.

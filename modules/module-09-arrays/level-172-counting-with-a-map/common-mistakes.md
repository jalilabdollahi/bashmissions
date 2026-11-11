# Common Mistakes

- **Using `+=` for counting.** `count[$plan]+=1` appends the text "1". After three lines you get `111`, not `3`.
  Right: `count[$plan]=$(( ${count[$plan]:-0} + 1 ))`
- **`((count[$plan]++))` with `set -e`.** For a new key the value is 0 before the increment, the expression evaluates to 0 (false), and `set -e` stops the script on the very first line.
- **Printing keys in map order.** `for p in "${!count[@]}"` gives an unspecified order. Sort first.
- **Forgetting `declare -A`.** Without it every plan name is evaluated as the number 0 and a single counter in slot 0 gets all the increments.
- **Reading input through a pipe.** `cat plans | while read ...; do count[...]...; done` fills the map in a subshell, and the report after the loop prints nothing.

# Common Mistakes

- **Looping over values and keeping a counter.** `n=0; for m in "${rack[@]}"; do ...; n=$((n+1))` works only until you skip or remove something. Use the real index.
- **Forgetting the `!`.** `for i in "${rack[@]}"` gives names, so `${rack[i]}` becomes `${rack[anchovy]}` and prints the wrong thing (or element 0).
- **A C-style loop on a sparse array.** After `unset 'rack[1]'`, `for ((i=0;i<${#rack[@]};i++))` stops one index too early. `"${!rack[@]}"` is safe.
- **Printing the zero-based index to a human.** The label says slot 1, not slot 0. Add one when you display.
- **Dropping the quotes.** `for i in ${!rack[@]}` works for numbers, but the habit breaks on associative arrays with spaces in keys.

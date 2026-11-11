# Common Mistakes

- **Square brackets or a plain string.** `rota="$1 $2 $3"` is one long string, not three elements. `declare -p rota` will show `declare -- rota="a b c"` (no `-a`).
  Right: `rota=("$1" "$2" "$3")`
- **Commas between items.** `rota=(a, b, c)` creates the elements `a,` `b,` `c`. Arrays are separated by spaces.
- **Spaces around the equals sign.** `rota = (a b c)` is a syntax error. Right: `rota=(a b c)`.
- **Forgetting quotes around an item that may contain spaces.** `rota=($1 $2 $3)` with "old flounder" gives four elements. Right: `rota=("$1" "$2" "$3")`.
- **Counting from 1.** The first element is `[0]`. `declare -p` shows the real indexes.

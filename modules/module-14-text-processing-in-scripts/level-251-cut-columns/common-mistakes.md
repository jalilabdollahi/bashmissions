# Common Mistakes

- **Forgetting the delimiter.** `cut -f2,5 "$1"` splits at tabs, finds none, and prints the whole line. Right: `cut -d, -f2,5 "$1"`.
- **Counting from zero.** Fields start at 1. `cut -d, -f1` is the invoice number, not the customer.
- **Expecting reordering.** `cut -d, -f5,2 "$1"` still prints the customer first, because `cut` keeps file order. To swap columns you need awk.
- **An unquoted special delimiter.** `cut -d ' ' -f1` is fine, but `cut -d ;` lets the shell treat `;` as a command separator. Quote it: `cut -d';' -f1`.
- **Quoted CSV cells.** A line like `7,"Pier, North",9` has four comma-separated pieces to `cut`, not three. Only use `cut` on data where the delimiter never appears inside a field.

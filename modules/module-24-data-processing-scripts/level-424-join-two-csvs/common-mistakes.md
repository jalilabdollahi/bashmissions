# Common Mistakes

- **Listing the files in the wrong order.** `awk ... "$1" "$2"` loads the invoices as the "lookup" and prints nothing sensible. The lookup file must come first on the command line.
- **Using `NR == 1` for the second header.** `NR` keeps counting across files, so the invoices header is not line 1 any more. Use `FNR == 1`.
- **Forgetting `next` in the loading rule.** Without it, every customer line also falls through to the print rules and appears in the output.
- **Reading a missing key to test it.** `if (name[$2] == "")` creates `name[$2]` as a side effect. Use `($2 in name)`.
- **Using `join` and trusting it.** `join` on unsorted files silently produces partial output, and without `-a 1` it drops invoices with unknown customers.

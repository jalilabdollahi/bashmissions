# Common Mistakes

- **Leaving the quotes off.** `printf '%s\n' ${customers[@]}` splits "Tidewater Books" into two lines and expands `*` into file names.
  Right: `printf '%s\n' "${customers[@]}"`
- **Using `[*]` inside quotes.** `"${customers[*]}"` is a single word: all names glued with spaces. One line instead of three.
- **Using `$customers`.** A bare array name is only element 0. `echo "$customers"` prints just the first customer.
- **Forgetting that `printf` runs once for an empty list.** `printf 'invoice: %s\n' "${empty[@]}"` prints `invoice: ` with nothing after it.
- **Expecting `echo` to print one per line.** `echo "${customers[@]}"` puts everything on a single line separated by spaces.

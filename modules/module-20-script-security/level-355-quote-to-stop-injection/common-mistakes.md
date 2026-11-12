# Common Mistakes

- **Quoting only the first use.** Wrong: `cp t.txt "$target"` followed by `echo filed: $target`; the message line splits and globs. Right: quote every expansion, or build the text once and print it with `printf '%s\n' "$target"`.
- **Quoting the variable but not the glued path.** Wrong: `tickets/"$customer".txt` is fine, but `"tickets/"$customer".txt"` leaves a gap that is easy to mistype. Right: one pair around the whole word, `"tickets/$customer.txt"`.
- **Single quotes around a variable.** Wrong: `cp t.txt 'tickets/$customer.txt'` creates a file literally named `$customer.txt`. Right: double quotes expand variables and still protect the result.
- **Thinking `;` in an argument is dangerous by itself.** It is only dangerous when a second shell reads it (`eval`, `bash -c`, `ssh`). Quoting keeps it inert here; level 356 covers the places where it does not.
- **Using `echo` for data.** Wrong: `echo $customer` with a name of `-n` prints nothing. Right: `printf '%s\n' "$customer"`.

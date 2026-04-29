# Common Mistakes for printf vs echo

- Using `echo "$1"` instead of `printf '%s\n' "$1"`.
  On some systems `echo` interprets `\n` as a newline, producing wrong output for inputs like `a\nb`.

- Using `printf "%s\n" "$1"` with a double-quoted format string.
  The format string itself should use single quotes to avoid variable expansion there.

- Forgetting the `raw: ` prefix.
  The expected output starts with `raw: ` before the argument value.

- Printing `*` and seeing it glob-expanded.
  Always quote `"$1"` to prevent word splitting and glob expansion.

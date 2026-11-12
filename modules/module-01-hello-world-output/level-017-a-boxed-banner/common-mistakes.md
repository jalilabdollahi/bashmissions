# Common Mistakes

- **Typing the border by hand.** It works until the box needs a different width.
  Wrong: `echo "=============================="`
  Right: `printf '=%.0s' {1..30}; printf '\n'`
- **Forgetting the newline after the repeated border.** The title row then starts on the same line.
  Wrong: `printf '=%.0s' {1..30}`
  Right: `printf '=%.0s' {1..30}; printf '\n'`
- **Using `%s` instead of `%.0s`.** `printf '=%s' {1..30}` prints `=1=2=3...`
- **Putting the range in quotes.** `"{1..30}"` is not expanded and printf runs once.
- **Wrong field width.** If the middle line is not 30 characters wide the right edge sticks out or in.

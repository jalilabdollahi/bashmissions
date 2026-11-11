# Common Mistakes

- **Using `$#` as if it were the last argument.** It is a count, not a value.
  `./solution.sh a b c` has `$#` equal to 3, not `c`.
- **Counting words by eye.** `./solution.sh "blue whale" eel` has two arguments,
  not three. Quotes group words before the script runs.
- **Forgetting the `$`.** `echo "batch size: #"` prints a literal hash sign.
- **Writing `${#1}` when you mean `$#`.** `${#1}` is the *length of the first
  argument*. For `blue` it is 4, and it does not count arguments at all.

# Common Mistakes

- **Quoting the stars.** `[[ $line == "*$word*" ]]` looks for a line that literally
  contains a star. Quote only the variable: `*"$word"*`.
- **Leaving the word unquoted.** `[[ $line == *$word* ]]` with `word='[WARN]'`
  matches any line with a W, A, R or N in it. Quote it: `*"$word"*`.
- **Forgetting to count blank and non-matching lines.** Numbering only matches
  gives wrong line numbers. Increment `lineno` for every line, inside the loop but
  outside the `if`.
- **Dropping the final line.** Without `|| [[ -n $line ]]`, a log whose last line
  lacks a newline loses its last entry.

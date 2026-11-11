# Common Mistakes

- **Expecting the script's `$1` inside the function.** Writing
  `describe() { echo "$1"; }` and calling plain `describe` prints an empty line.
  Right: pass it, `describe "$1" "$2"`.
- **Forgetting the quotes at the call.** `describe dory east 3` hands over three
  words: name `dory`, count `east`. Right: `describe "dory east" 3`.
- **Writing arguments inside the parentheses.** `describe(name, count) { ... }`
  is a syntax error. Bash functions always have empty `()`; arguments are
  positional.
- **Using the function's name as `$0`.** `$0` inside the function is still the
  script's name. Use `${FUNCNAME[0]}` if you need the function's name.

# Common Mistakes

- **Keeping eval "but quoted".** Wrong: `eval "grep \"$pattern\" logs/app.log"`; a pattern containing a double quote closes the quoting and the rest is code. Right: no eval, `grep -e "$pattern" logs/app.log`.
- **Putting the whole command in one variable.** Wrong: `cmd="grep -i"; $cmd "$pattern" f` works until a flag has a space, and `"$cmd"` fails outright. Right: `cmd=(grep -i); "${cmd[@]}" "$pattern" f`.
- **Forgetting the quotes on the array.** Wrong: `grep ${flags[@]} ...` splits and globs the elements again. Right: `"${flags[@]}"`.
- **Letting user words become flags.** Wrong: `flags+=("--$word")` lets a user pick `--exec`-style options. Right: map each allowed word to a literal flag in `case`, and reject the rest.
- **Forgetting `-e` for the pattern.** Wrong: `grep "$pattern" file` with `pattern=-v` reads a flag. Right: `grep -e "$pattern" file`.

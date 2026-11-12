# Common Mistakes

- **Data as the format.** Wrong: `printf "$tag\n"` with `tag=50%d` prints `50` and an error, and `%n`-style sequences can misbehave. Right: `printf '%s\n' "$tag"`.
- **Forgetting the newline.** Wrong: `printf '%s' "$tag"` glues all tags into one line. Right: the format ends with `\n`.
- **Missing quotes around the argument.** Wrong: `printf '%s\n' $tag` splits `Spare  Machine` into two lines. Right: `"$tag"`.
- **Using `%d` for something that may not be a number.** Wrong: `printf '%d\n' "$input"` errors on text. Right: `%s` for text, `%d` only for integers you have checked.
- **Trusting `echo -e` to be portable.** Wrong: `echo -e "a\tb"` prints `-e a<tab>b` in some shells. Right: `printf 'a\tb\n'`.

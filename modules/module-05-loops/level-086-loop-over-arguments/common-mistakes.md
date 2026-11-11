# Common Mistakes

- **Leaving off the quotes around `$@`.** Spaces split names apart.
  Wrong: `for name in $@; do` turns "Harbour Bakery" into Harbour and Bakery
  Right: `for name in "$@"; do`
- **Quoting the loop variable only at the start.** Forgetting quotes in the body breaks the same way.
  Wrong: `echo "report" > reports/$name.txt` (ambiguous redirect when the name has spaces)
  Right: `echo "report" > "reports/$name.txt"`
- **Using `"$*"` instead of `"$@"`.** It glues all arguments into one string, so the loop runs once.
  Wrong: `for name in "$*"; do` prints one line with all names joined
  Right: `for name in "$@"; do`
- **Creating the directory inside the loop without `-p`.** The second round fails because `reports` already exists. Use `mkdir -p` once, before the loop.

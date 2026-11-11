# Common Mistakes

- **One giant `main` block.** Pasting everything into a single 60-line sequence
  defeats the module's purpose. If you copy-paste twice, make it a function.
- **Messages on stdout.** If `log` or `die` printed to stdout, then
  `slug=$(slugify ...)` would not be the only thing a caller captures, and a
  pipeline reading `home=...` would see the log lines too.
- **Range test before the type test.** `(( $1 >= 1 ))` on `lots` does not fail
  cleanly. Put the regex check first and join with `&&`.
- **`tr -c` without `-s`.** `tr -c 'a-z0-9' '-'` turns "Gull & Anchor" into
  `gull---anchor`. The `-s` squeezes the run into a single hyphen; the `sed` trims
  the ends.
- **Using `$( )` around `die`.** `x=$(die 3 "...")` exits only the subshell, so the
  script carries on. Call `die` directly.

# Common Mistakes

- **Redacting the whole line.** Wrong: `s/.*password.*/REDACTED/` destroys the context the support desk needs. Right: capture the key and replace only the value.
- **Using `*` for the value.** Wrong: `password=[^ ]*` also rewrites the harmless `password=` into `password=[REDACTED]`. Right: use `+`, which needs at least one character.
- **Forgetting the `g` flag.** Wrong: `s/token=.../` fixes only the first secret on a line. Right: end the expression with `g`.
- **Stopping at a space only.** Wrong: `token=[^ ]+` swallows `&page=2` in a query string. Right: stop at whitespace or `&`: `[^[:space:]&]+`.
- **Slashes in the pattern with `/` as delimiter.** Wrong: `s/(://...)/` ends the expression early with a confusing sed error. Right: pick another delimiter, `s#...#...#`.

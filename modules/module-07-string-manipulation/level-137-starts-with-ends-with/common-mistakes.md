# Common Mistakes

- **Quoting the pattern.** `[[ $name == ".*" ]]` is only true for a name that is
  literally `.*`. Leave the star outside the quotes: `[[ $name == .* ]]`.
- **The star on the wrong side.** `[[ $name == *backup- ]]` asks for a name that
  ENDS with `backup-`. "Starts with" needs the star after the text.
- **Wrong rule order.** Testing `backup-*` before `*.pem` labels
  `backup-server.pem` as archive, but the spec says quarantine.
- **Using `=~` for this.** That is a regular expression (a later level), where `.`
  and `*` mean something different. Use `==` for glob tests.

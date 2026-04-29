# Common Mistakes for Print Version Info

- Spaces around `=` in assignment: `name = "$1"`. Bash reads this as "run the command `name` with arguments `=` and `$1`" and fails.

- Single-quoting the output: `echo '$name version $version'` prints the literal text including dollar signs. Use double quotes so variables expand.

- Wrong word between the variables. The expected format is `<name> version <version>` — singular `version`, all lowercase. `Version` or `ver` won't match.

- Forgetting to copy `$2`. If you only assign `name="$1"` and reference `$2` later, the script still works, but the level explicitly asks for two named variables — use them both.

- Trailing punctuation. `echo "$name version $version."` adds a period the test doesn't expect.

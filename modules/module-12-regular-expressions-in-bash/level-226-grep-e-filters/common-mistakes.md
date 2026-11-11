# Common Mistakes

- **Forgetting `-E`.** `grep ' (401|403|429) ' file` uses basic regex, where the
  parentheses and bars are plain text, so nothing matches. Use `grep -E`.
- **Using `egrep` or `grep -P`.** `egrep` is deprecated and `-P` (Perl regex) is not
  available everywhere, notably not in macOS's default grep.
- **Loose patterns.** `grep -E '401|403|429'` also hits `/files/403.png`, `1403`
  and `4011`. Add the delimiters: `' (401|403|429) '`.
- **Letting "no match" end the script.** With `set -e`, a grep that finds nothing
  returns 1 and the script stops silently. Add `|| true` when an empty result
  is fine.
- **Using `[[ ... ]]` syntax inside grep.** grep takes the regex as an ordinary
  argument: quote it with single quotes, no `=~`, no `[[`.

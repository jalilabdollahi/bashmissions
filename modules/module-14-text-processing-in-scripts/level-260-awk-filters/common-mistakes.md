# Common Mistakes

- **Using = instead of ==.** `awk '$2 = "P1" { print }'` assigns "P1" to the field and is always true, so every line is printed (rewritten). Comparison is `==`.
- **Quoting a number.** `$3 > "3"` forces a text comparison, so `12 > "3"` is false. Leave numbers unquoted.
- **Forgetting quotes on text.** `$2 == P1` compares the field to an awk variable called `P1`, which is empty. Write `$2 == "P1"`.
- **Putting the condition inside the braces without if.** `awk '{ $2 == "P1" && print }'` is a syntax error. Condition before the braces, or `if` inside them.
- **Expecting a pattern to match substrings.** `$5 == "open"` does not match `open-ish`. Use `$5 ~ /open/` for a regular expression, which is a different operator.

# Common Mistakes for Negate a Condition

- Using string comparison operators for numeric tests, or numeric operators for strings.
- Forgetting spaces inside `[ ... ]`; `["$1" = yes]` is not valid test syntax.
- Leaving variables unquoted in single-bracket tests, which breaks empty values and values with spaces.
- Printing extra debug text that the exact-output validator does not expect.

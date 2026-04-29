# Lowercase Variable

Pair partner of `${var^^}`. Same syntax, opposite direction.

| Form         | Effect                                     |
|--------------|--------------------------------------------|
| `${name,}`   | lowercase the first character              |
| `${name,,}`  | lowercase every character                  |
| `${name,,[A-M]}` | lowercase only `A`–`M`                 |

Common use cases:

- Normalising user input for case-insensitive comparison:
  ```bash
  read -r answer
  if [[ "${answer,,}" == "yes" ]]; then ...
  ```
- Building consistent tag/key names from mixed-case sources.
- Making CLI flags forgiving:
  ```bash
  case "${1,,}" in
    --help|-h) ... ;;
    --version|-v) ... ;;
  esac
  ```

Behaviour notes:

- Non-letters pass through untouched.
- Locale-aware: in a UTF-8 locale, `Ä` becomes `ä`. In `C` locale, only A–Z map.
- Idempotent: lowercasing an already-lowercase string is a no-op.

```bash
text="MiXeD CaSe"
echo "${text,,}"   # mixed case
```

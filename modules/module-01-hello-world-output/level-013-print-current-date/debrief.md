# Print Current Date

**Command substitution** captures the stdout of a command and inserts it into another string. The two equivalent forms in Bash:

- `$(command)` — modern, nestable, recommended.
- `` `command` `` — legacy backticks; harder to read and to nest.

The `date` utility takes a format string starting with `+`. Useful tokens:

| Token | Meaning           | Example  |
|-------|-------------------|----------|
| `%Y`  | 4-digit year      | `2026`   |
| `%m`  | 2-digit month     | `04`     |
| `%d`  | 2-digit day       | `29`     |
| `%H`  | hour (00–23)      | `14`     |
| `%M`  | minute (00–59)    | `07`     |
| `%S`  | second (00–59)    | `33`     |
| `%F`  | shorthand for `%Y-%m-%d` | `2026-04-29` |
| `%T`  | shorthand for `%H:%M:%S` | `14:07:33` |

```bash
echo "today is $(date +%Y-%m-%d)"
# today is 2026-04-29
```

Because the value changes daily, the test uses a regex `today is \d{4}-\d{2}-\d{2}` rather than a fixed string.

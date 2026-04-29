# Unset a Variable

`unset` removes a variable from the shell's symbol table. It's the inverse of assignment.

| Operation     | After it, the variable is...           |
|---------------|----------------------------------------|
| `name=value`  | set, with the given value              |
| `name=`       | set, with empty string                 |
| `unset name`  | not set — completely gone              |

The difference matters once you start using parameter expansions like `${var-default}` and `${var:-default}`:

| Expansion         | Triggers when var is...   |
|-------------------|---------------------------|
| `${var-default}`  | unset only                |
| `${var:-default}` | unset **or** empty string |
| `${var=default}`  | unset (and assigns)       |
| `${var:=default}` | unset or empty (assigns)  |

`unset` also takes flags: `-v` (variable, default), `-f` (function), `-n` (the name reference, not the target).

```bash
v="hello"
echo "before: $v"   # hello
unset v
echo "after: ${v:-empty}"   # empty
```

Useful in cleanup paths, in `trap` handlers, and when a function wants to scrub temporary state before returning.

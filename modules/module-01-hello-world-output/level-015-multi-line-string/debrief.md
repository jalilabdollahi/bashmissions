# Multi-line String

A **here-document** ("heredoc") is the cleanest way to feed a multi-line block of text to a command's stdin in Bash. The form:

```bash
cat <<EOF
first line
second line
EOF
```

Anatomy:

- `<<EOF` — start the heredoc; `EOF` is the *delimiter* (any token works: `END`, `DONE`, `STOP`).
- The lines that follow become stdin for the command before `<<`.
- A line containing only the delimiter ends the block.

Variations worth knowing:

| Form         | Behavior                                                  |
|--------------|-----------------------------------------------------------|
| `<<EOF`      | Variables and `$()` expand inside the body.               |
| `<<'EOF'`    | Quoted delimiter — body is **literal**, no expansion.     |
| `<<-EOF`     | Strips leading **tabs** from each body line (only tabs).  |

Heredocs are how scripts emit usage strings, generated config files, and SQL blocks without escaping every quote.

```bash
cat <<EOF
line one
line two
line three
EOF
```

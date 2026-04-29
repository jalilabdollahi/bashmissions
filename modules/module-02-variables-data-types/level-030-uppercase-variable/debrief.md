# Uppercase Variable

Bash 4.0 added a small family of **case-conversion** parameter expansions:

| Form         | Effect                                     | Example: `name="hello world"` |
|--------------|--------------------------------------------|------------------------------|
| `${name^}`   | uppercase first character                  | `Hello world`                |
| `${name^^}`  | uppercase all characters                   | `HELLO WORLD`                |
| `${name,}`   | lowercase first character                  | `hello world` (no change)    |
| `${name,,}`  | lowercase all characters                   | `hello world`                |
| `${name~}`   | toggle case of first character             | `Hello world`                |
| `${name~~}`  | toggle case of all characters              | `HELLO WORLD`                |

You can also limit which characters are converted by adding a pattern:

```bash
name="hello world"
echo "${name^^l}"     # heLLo worLd  — only `l` characters
echo "${name^^[aeiou]}"   # hEllO wOrld
```

Why use these instead of `tr` or `awk`?

- No subprocess: parameter expansion is in-process and fast inside loops.
- No quoting headaches around `[:upper:]` etc.
- Reads more naturally for one-off transforms.

When to fall back to `tr`:

- Compatibility with macOS's default Bash 3.2 (no case-conversion expansions).
- Streaming a large file rather than transforming a single string.

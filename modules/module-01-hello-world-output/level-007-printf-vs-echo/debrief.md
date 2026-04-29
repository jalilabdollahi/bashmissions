# printf vs echo

This level demonstrates why `printf` is more reliable than `echo` for printing arbitrary data.

`echo` may interpret escape sequences like `\n` as a newline depending on the shell or flags. `printf` with `%s` always prints the argument as a raw string.

Key takeaway:

- `printf 'raw: %s\n' "$1"` — the `%s` specifier never interprets the value.
- `echo "$1"` — may or may not interpret `\n` as a newline.

Example run:

```bash
./solution.sh 'a\nb'
# raw: a\nb
./solution.sh '*'
# raw: *
```

Use `printf '%s\n'` whenever you need to print values that might contain backslashes or shell metacharacters.

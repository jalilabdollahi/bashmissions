# Colorized Output

Most terminals interpret a small set of byte sequences starting with the **ESC** character (`0x1B`, written `\033` in octal or `\e` in some contexts). These are called **ANSI escape codes** or **CSI sequences**.

The form is `ESC [` then a code then a single letter:

| Sequence    | Effect                       |
|-------------|------------------------------|
| `\033[0m`   | reset all attributes         |
| `\033[1m`   | bold                         |
| `\033[31m`  | red foreground               |
| `\033[32m`  | green foreground             |
| `\033[33m`  | yellow foreground            |
| `\033[34m`  | blue foreground              |
| `\033[41m`  | red background               |
| `\033[2J`   | clear screen                 |

The pattern is always: turn an attribute **on**, write your text, turn it back **off** with `\033[0m` so the next line isn't tainted.

```bash
printf '\033[32mOK\033[0m\n'   # green OK
printf '\033[31mFAIL\033[0m\n' # red FAIL
```

When stdout is not a terminal (piping into a file, for instance), check `[ -t 1 ]` first and skip colors so logs don't end up full of `\033[32m` noise.

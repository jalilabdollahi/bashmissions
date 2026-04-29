# Common Mistakes for Colorized Output

- `echo '\033[32mOK\033[0m'` (no `-e`) prints the literal characters instead of the escape codes. Either use `printf` or pass `-e` to `echo`.

- Single quotes vs. double quotes don't matter for octal escapes inside `printf`. But `$'...'` strings *do* expand backslash escapes — they produce real ESC bytes for assignment, e.g. `green=$'\033[32m'`.

- Forgetting the reset: `\033[32mOK` (without the trailing `\033[0m`) leaves every line afterwards in green until the terminal sees a reset.

- Wrong color number. `\033[3` plus a digit `0..7` are foreground colors, `\033[4` + digit are background. `\033[32m` is green; `\033[2m` is "dim" — easy to mistype.

- Dumping color codes to a non-tty. Pipe a colorized script through `cat -v` and you'll see `^[[32mOK^[[0m`. Always check `[ -t 1 ]` before colorizing in production scripts.

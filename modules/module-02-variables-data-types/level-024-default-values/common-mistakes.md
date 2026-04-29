# Common Mistakes for Default Values

- Writing `${var:-default}` and expecting `$var` to now hold `default`. It doesn't — only `${var:=default}` (with `=`) actually assigns.

- Forgetting the colon: `${var-default}` is *strict* — only an unset variable triggers the default. An empty string passes through untouched.

- Quoting issues. `name="${1:-anonymous}"` is correct; `name=${1:-anonymous}` is also fine, but `name=${1:-"my default"}` puts `my default` (without quotes!) — Bash already treats the inside of the expansion as a single word. Use `name="${1:-my default}"` to keep the spaces.

- Using `if [ -z "$1" ]; then name=anonymous; else name="$1"; fi` instead of the one-liner. Works, but the parameter expansion is the canonical Bash idiom — six lines of conditional collapse to one.

- Putting a space: `${var :- default}` is a syntax error. No spaces inside the expansion.

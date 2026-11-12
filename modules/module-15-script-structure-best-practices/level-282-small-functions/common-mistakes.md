# Common Mistakes

- **Printing "yes" or "no" for a check.** Wrong: `[ "$(is_port "$p")" = yes ]`. Right: `if is_port "$p"; then`, with the function's status carrying the answer.
- **A function that does two things.** Wrong: `validate_and_print`, which cannot be reused without printing. Right: `is_port` decides, `format_endpoint` prints.
- **Forgetting `10#`.** Wrong: `(( $1 > 0 ))` with `00080` or `09` errors or reads octal. Right: `(( 10#$1 > 0 ))`.
- **Reading globals instead of arguments.** Wrong: `is_port` that looks at `$port` in the caller. Right: `is_port "$port"` and use `$1` inside.
- **Letting main grow back.** Wrong: pasting new validation into the loop because it is "just one line". Right: add a named function and call it from main.

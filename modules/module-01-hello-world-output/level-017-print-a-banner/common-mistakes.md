# Common Mistakes for Print a Banner

- Hand-counting spaces. The whole point of `%-10s` is to let printf do the math. Solutions like `echo "== $1         =="` work for one input length and break for others.

- Right-aligning by mistake: `%10s` (no minus sign) pads on the **left**, not the right. The expected format is left-aligned, so the title appears immediately after `== `.

- Forgetting `\n` in the format string. `printf` does not add a trailing newline; without it the next line will run together.

- Quoting the format with double quotes when single will do: `printf "%-10s" "$1"` works but `$` in a format string can bite you. Prefer single-quoted formats.

- Adding extra padding outside the field: `printf '==  %-10s  =='` (two spaces each side) makes the banner 2 columns wider than the test expects.

# Common Mistakes for Use a Variable

- `echo "$name_suffix"` when you meant `echo "${name}_suffix"`. The first reads variable `name_suffix` (unset → empty); the second concatenates `$name` with `_suffix`.

- Skipping the double quotes: `echo $name` performs word splitting. If `$name` is `has spaces`, you get two arguments to echo. Always quote.

- Using single quotes around the variable: `echo '$name'` prints the literal text `$name`. Single quotes suppress all expansion.

- Using `${var}` everywhere out of habit. It's not wrong, just noisy when not needed: `echo "$name"` is cleaner than `echo "${name}"`.

- Believing `${name}` somehow "evaluates" or "calls" the variable. It just expands to the value, exactly like `$name` — the only purpose of the braces is to terminate the variable name.

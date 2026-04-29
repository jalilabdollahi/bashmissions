# Common Mistakes for Integer Variables

- Assigning a non-numeric string to a `-i` variable: `n="hello"` silently sets `n=0` because `hello` is treated as an unset name in arithmetic. No error.

- Forgetting the attribute is sticky. Once `declare -i n` is run, *every* later `n=...` is arithmetic — even one that's supposed to be a string assignment.

- Using `declare -i` in a function and expecting it to apply globally. Inside a function, `declare` defaults to **local** scope. Use `declare -gi` for global.

- Assuming `declare -i` enables arithmetic on the right side of `=` for *all* variables. It only affects the variable being declared. `m="$n + 1"` (with `m` not `-i`) stores the literal string.

- Spaces around the operator: `n += 10` is **not** assignment — it's a command call. The form is `n+=10` (no spaces).

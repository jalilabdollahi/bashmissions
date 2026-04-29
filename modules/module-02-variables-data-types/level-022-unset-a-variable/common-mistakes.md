# Common Mistakes for Unset a Variable

- Confusing `unset v` with `v=`. The first removes the variable; the second sets it to empty string. They behave differently in `${v:-default}` only when paired with the non-`:` form `${v-default}`.

- Trying to `unset $v` (with the dollar sign). That expands `$v` to its value first, then tries to unset a variable with that name — almost never what you want. Always `unset v`, no dollar sign.

- Trying to `unset` a `readonly` variable. Bash refuses; the variable stays.

- Forgetting that `unset` works on functions too. `unset -f myfn` removes a function definition. Without `-f` it looks for a variable first.

- Using `unset` in a function and expecting it to remove a variable from the parent shell. Inside a function, `unset` follows scope rules — it removes the local copy first.

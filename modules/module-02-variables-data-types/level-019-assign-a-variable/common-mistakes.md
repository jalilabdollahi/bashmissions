# Common Mistakes for Assign a Variable

- `name = "value"` (spaces around `=`). Bash reads this as a command call and fails with `name: command not found`.

- Forgetting to quote the value. `name=$1` works for simple inputs but breaks when `$1` contains whitespace — Bash splits the assignment at the space.

- Using `$name` on the **left** side of `=`. The left side is just the variable name; only the right side gets expanded.

- Trying to declare a type: `int x=5` doesn't exist. Use `declare -i x=5` if you need integer behaviour (covered in level 23).

- Confusing assignment with comparison. `[[ $a = "x" ]]` (with spaces) is comparison; `a="x"` (no spaces) is assignment.

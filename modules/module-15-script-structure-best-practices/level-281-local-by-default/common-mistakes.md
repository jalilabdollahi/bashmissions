# Common Mistakes

- **Assuming functions have their own scope.** Wrong: `name=${1^^}` in a helper while the caller reads `$name` afterwards. Right: `local name=${1^^}`.
- **Masking a failure with local.** Wrong: `local out=$(grep x "$f")` always succeeds because `local` succeeded. Right: `local out; out=$(grep x "$f")`.
- **Declaring local outside a function.** `local` at the top level of a script is an error. Right: only inside function bodies.
- **Forgetting the loop variable.** Wrong: `for i in ...` in a function without `local i`, which overwrites the caller's `i`. Right: `local i` first.
- **Expecting local to hide variables from callees.** A function called by this one still sees its locals (dynamic scope). Right: pass values as arguments instead of relying on that visibility.

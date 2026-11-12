# Common Mistakes

- **Walking through the steps one by one.** Wrong: `for k in 1..n` calling `try-steps` each time costs up to N rehearsals and fails the call-count check. Right: halve the range with `mid=$(( (lo + hi) / 2 ))`.
- **Moving `hi` to `mid - 1` on failure.** The failing step may be `mid` itself, so you would skip the answer. Right: `hi=$mid` on failure, `lo=$(( mid + 1 ))` on success.
- **Looping forever with `lo <= hi`.** With `hi=$mid` the interval can stop shrinking when `lo == hi`. Right: `while (( lo < hi ))`.
- **Printing the array element at the position.** Wrong: `${steps[lo]}` names the step after the culprit. Right: `${steps[lo - 1]}`: positions start at 1, indexes at 0.
- **Letting `try-steps` abort the script.** A bare `try-steps "$mid"` under `set -e` exits on the first failing rehearsal. Right: use it as an `if` condition, and discard its output with `> /dev/null 2>&1`.

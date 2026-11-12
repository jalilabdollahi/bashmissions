# Common Mistakes

- **Forgetting `declare -A`.** `owners[dory]=Priya` on a normal array writes slot 0. Symptom: every lookup returns the last owner in the file.
  Right: `declare -A owners` before the first assignment.
- **Declaring with `=()`.** `owners=()` creates an indexed array. Use `declare -A owners`.
- **Declaring inside a function and reading outside.** `declare` in a function makes the variable local. Use `declare -gA` if the map must survive the function.
- **Printing a missing key as an empty string.** `${owners[$s]}` for an unknown server is empty; add `:-unassigned` so the output says something.
- **Assuming insertion order.** Looping over `"${!owners[@]}"` returns keys in an unspecified order. Never rely on it.

# Common Mistakes

- **Passing the expanded array.** `summarize "${web[@]}"` hands over every element as a separate argument, and `$1` is only the first host. Pass the name: `summarize web`.
- **Passing `$web`.** That is element 0 only, a single host name, not the array.
- **A reference named like the array.** `local -n web=$1` inside a function called with `web` loops back on itself ("circular name reference"). Choose a different name such as `list`.
- **Forgetting `local`.** `declare -n list=$1` at function level leaks the alias into the whole script, and the next call may fail because `list` already points somewhere.
- **Reading the last element of an empty array.** `${list[-1]}` fails with "bad array subscript" when the array is empty. Test the count first.

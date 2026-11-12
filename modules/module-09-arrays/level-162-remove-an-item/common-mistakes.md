# Common Mistakes

- **Unquoted subscript.** `unset fleet[$i]` can be globbed against file names. With a file called `fleet1` in the directory, nothing is removed.
  Right: `unset 'fleet[$i]'`
- **Expecting the others to shift down.** After `unset 'fleet[1]'`, the old `fleet[2]` is still `fleet[2]`, and `${fleet[1]}` is empty. Do not rely on positions after removals.
- **Setting to empty instead of removing.** `fleet[1]=""` keeps the slot, so `${#fleet[@]}` still counts it. Only `unset` removes it.
- **Unsetting the array name.** `unset fleet` deletes the whole array, not one element.
- **Computing the "last index" from the length.** After removals `${#fleet[@]}-1` may point into a gap. Use `${fleet[-1]}` for the last element.

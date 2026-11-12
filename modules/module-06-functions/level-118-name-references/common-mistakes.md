# Common Mistakes

- **Passing the value, not the name.** `add_unique $seen "dory"` passes the first
  element's text. Right: `add_unique seen "dory"`.
- **Alias with the caller's name.** `local -n seen=$1` called as `add_unique seen x`
  gives "circular name reference". Use a different alias, e.g. `list`.
- **Forgetting `local`.** `declare -n list=$1` without `local` leaves the alias alive
  after the function, which can confuse the next call. Keep it `local -n`.
- **Copying instead of referencing.** `local copy=("${list[@]}")` and appending to
  `copy` changes nothing in the caller.
- **Quoting the expansion wrongly.** `for item in ${list[@]}` splits elements that
  contain spaces. Right: `"${list[@]}"`.

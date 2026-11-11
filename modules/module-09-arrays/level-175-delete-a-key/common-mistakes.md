# Common Mistakes

- **Emptying instead of deleting.** `roster[$login]=""` leaves the key. A later `for u in "${!roster[@]}"` still visits it and the user stays valid.
  Right: `unset 'roster[$login]'`
- **Unquoted unset.** `unset roster[$login]` is a glob: with a file named `roster1` it may remove nothing, or the wrong thing.
- **Counting every argument.** Without the `-v` test, unknown and repeated logins are counted as revoked.
- **Unsetting the whole map.** `unset roster` deletes the variable; afterwards `declare -A roster` is gone and the next `roster[$x]=...` creates a plain indexed array.
- **Deleting while iterating the keys by position.** Removing from an array you are walking with a C-style counter skips the next element. Loop over a copy of the keys (`"${!roster[@]}"` is expanded once before the loop starts).

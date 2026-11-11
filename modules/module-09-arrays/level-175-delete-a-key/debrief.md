# Debrief: Delete a Key

`unset 'map[$key]'` removes a key and its value from an associative array. Setting the value to an empty string only changes the value; the key stays.

## How it works
In a map, existence is part of the data. Every key is either present or absent, and `unset` moves a key from present to absent. After that, `${#map[@]}` is smaller, `"${!map[@]}"` no longer lists it, and `[[ -v map[$key] ]]` is false. A blanked entry keeps all of those unchanged. When a later step treats "each key" as "each valid user", the difference is a security question.

Unsetting a missing key is silently fine. You do not need a guard to avoid errors, only to know whether something was actually removed, as in this level's counter.

The quotes in `unset 'map[$key]'` guard against filename expansion: the unquoted word `map[$key]` is a glob pattern, and if a file named `map1` happens to exist, the shell replaces the word with that file name and `unset` removes the wrong thing. Quoting makes the subscript reach `unset` untouched.

Mind the key type. Removing from an associative array works by key text. In an indexed array it removes by number and leaves a gap, as you saw a few levels ago.

## In real work
Revoking access, expiring cache entries, dropping hosts from a pool, cleaning up after a state machine.

## Going further
Next you will hand an array to a function, which needs a trick of its own.

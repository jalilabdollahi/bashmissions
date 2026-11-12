# Debrief: Arrays into Functions

Functions take strings, not arrays. To give a function an array, give it the array's name and let a name reference (`local -n`) turn that name back into the variable.

## How it works
When you call `f "${web[@]}"`, the shell expands the array before the call. The function receives N separate arguments and has no idea they came from an array. For one list that is workable (`local items=("$@")`); for two lists, or for a function that should modify the caller's array, it is not.

`local -n ref=$1` solves that. The variable `ref` becomes an alias: every read and every write through `ref` happens on the variable named in `$1`. That also means a function can fill a caller's array (`ref+=("x")`) or empty it, with no copying and no output capturing. The array can be indexed or associative; the function does not care.

Two rules keep it safe. The name must not collide with the alias, because `local -n web=$1` called as `f web` makes `web` refer to itself and Bash complains about a circular reference. A common habit is to give references odd, unlikely names such as `_list`. And name references need Bash 4.3 or later.

## In real work
Helper functions for "print this list", "add to this list", "check membership" that you can reuse on any array in a longer script.

## Going further
The last two levels combine everything: building a map from two lists, and storing a whole grid in one map with composite keys.

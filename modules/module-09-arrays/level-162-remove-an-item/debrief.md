# Debrief: Remove an Item

An array in Bash is not a tightly packed row; it is a set of numbered slots, and `unset` empties one slot without touching the others.

## How it works
Under the hood an indexed array is a sparse structure, closer to a map from numbers to values than to a C array. Unsetting index 1 deletes that entry. Index 2 stays index 2. That is why `declare -p` is so useful: it prints the actual indexes, so you can see the gap.

Two practical consequences. First, `${#arr[@]}` is the number of elements present, not the highest index plus one, so you cannot use it to compute "the next free index" after removals (that is one reason `+=` exists). Second, a loop of the form `for ((i=0; i<${#arr[@]}; i++))` visits the wrong slots on a sparse array. The next level shows the robust loop.

The quote in `unset 'arr[$i]'` guards against filename expansion: an unquoted `arr[1]` can match a file named `arr1` in the current directory, and then unset receives that file name instead.

## In real work
Taking a host out of rotation, dropping a finished job from a queue, filtering a list in place.

## Going further
Next you will cut a range out of an array with a slice, without changing the array at all.

# Debrief: Iterate Indexes

`"${!arr[@]}"` is the list of an array's indexes. Loop over that when the position matters, and read the element with `${arr[i]}`.

## How it works
The `!` is read as "indirection to the keys". For an ordinary array the keys are 0, 1, 2, and so on. For a sparse array they are only the keys that exist: after removing index 1 from a five-element array the expansion is `0 2 3 4`. That makes it the right tool for any loop that must cope with gaps, where counting from 0 to length-minus-one would visit empty slots and miss the tail.

Having both index and value lets you do things a value loop cannot: print positions, modify an element in place (`arr[i]=${arr[i]^^}`), compare neighbours (`arr[i]` against `arr[i-1]`), or remove elements while walking.

The same syntax works on associative arrays, where it produces the keys. You will use it that way in a few levels.

## In real work
Numbering output ("line 12: ..."), updating arrays in place, and walking two parallel arrays together by one shared index.

## Going further
So far all arrays were built from arguments. Next you will fill one from the lines of a file with `mapfile`.

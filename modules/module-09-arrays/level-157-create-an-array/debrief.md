# Debrief: Create an Array

An array is one variable with many numbered slots. Where `name=value` holds a single string, `name=(a b c)` holds a list, and each item has an index: 0, 1, 2, and so on.

## How it works
When Bash sees `=(`, it reads the words inside the brackets exactly as it would read the words of a command line: split on spaces, expand variables, strip quotes. That is why quoting matters here. `("$1" "$2")` makes two elements even when `$1` contains spaces, and `($1 $2)` could make many.

`declare -p` is your X-ray. When a script behaves oddly, printing the variable with `declare -p` shows whether you really have an array, how many elements, and whether the values contain what you think they contain.

## In real work
Anywhere a script handles "a list of things": hosts to patch, files to back up, flags to pass on to another program. Before arrays people used one long string and split it again later, which broke on the first name with a space.

## Going further
Next you will read single elements by index with `${rota[1]}`, and count from the end with negative indexes.

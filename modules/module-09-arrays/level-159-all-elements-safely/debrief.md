# Debrief: All Elements Safely

`"${arr[@]}"` is the one correct way to say "all the elements, each as its own word". Learn it as a unit: the braces, the `@` and the double quotes all matter.

## How it works
After Bash expands a variable it normally performs word splitting and filename expansion on the result. For a single string that is a nuisance; for a list of names it is a bug. Putting the expansion in double quotes switches that off, and the special `@` form tells Bash to produce a separate word for every element anyway. The result is the closest thing Bash has to "pass this list as it is".

The `*` form is the cousin that glues instead: `"${arr[*]}"` joins all elements into one word, separated by the first character of `IFS`. That is useful for building a single display string, never for passing items on to a command.

And an empty array expands to no words at all. That is perfect for commands like `ls "${files[@]}"`, but be careful with `printf`, which always runs its format at least once.

## In real work
Every time a script forwards a list to another command (`cp "${files[@]}" backup/`, `rm -- "${old[@]}"`), this is the form you use. Getting it wrong is a classic source of "it works until a name has a space in it".

## Going further
Next you will count how many elements an array has, which also solves the empty-array check you just wrote by hand.

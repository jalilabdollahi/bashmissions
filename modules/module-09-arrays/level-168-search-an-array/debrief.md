# Debrief: Search an Array

Searching an array means walking it and comparing. Bash gives you no `in` operator for indexed arrays, so a small loop is the idiom, and exactness is the part to get right.

## How it works
Inside `[[ ]]`, `==` compares strings, but with a catch: the right-hand side is a pattern unless it is quoted. `[[ $a == $b ]]` treats `$b` as a glob (`*`, `?`, `[abc]`), while `[[ $a == "$b" ]]` compares literally. Forgetting the quotes is a quiet security bug in guard scripts: a pattern entry like `*` becomes a wildcard.

The same reasoning explains why the "join and substring" trick is unsafe. Joining with spaces destroys the element boundaries, so two entries can fake a third. Searching element by element keeps the boundaries intact.

The answer also shows the other typical shape of a search: return early on success, fall through to "not found". In a function you would use `return 0` and `return 1`; at script level it is `exit`. The exit status becomes the answer that callers can test with `if`.

## In real work
Allow-lists and deny-lists, "is this host already registered?", validating a user's choice against a menu of valid options.

## Going further
Next you will put an array in order. Sorting is an external job (`sort`), and the lesson is how to send the array there and bring it back.

# Debrief: A Grid in a Map

A map key is just a string, so a key can carry more than one number. `grid[$row,$col]` is a two-dimensional table built from a one-dimensional structure.

## How it works
Inside the brackets of an associative array, Bash performs ordinary expansion: `grid[$r,$c]` becomes the key `2,3` when `r=2` and `c=3`. The comma has no special meaning; it only makes the key readable and unambiguous. You could just as well use `$r:$c` or `$r-$c`. The separator must be something that cannot occur inside a number, so `1,11` and `11,1` stay different keys; gluing the numbers with nothing (`$r$c`) would make them collide.

On an indexed array the same trick fails, because the subscript is evaluated as arithmetic and a comma there is the comma operator. That is a second reason to use `declare -A`.

The grid has no shape of its own. The map does not know how many rows or columns it holds, so you keep `rows` and `cols` in ordinary variables and loop with them. Reading outside the grid just gives an empty string.

The transposition shows why the key design pays off: swapping two nested loops flips the table, with no data movement at all.

## In real work
Game boards, spreadsheets and matrices, seat or rack plans, distance tables between hosts, any "x by y" data in a script.

## Going further
You now have lists, maps and tables. The next module shows how to connect scripts to the world with redirection and pipelines.

# Debrief: Counting with a Map

A counting map is an associative array whose values are numbers. Each input item either creates a key with value 1 or adds one to its current value.

## How it works
The central expression is `${count[$k]:-0}`: the current count, or 0 for a key that has never been seen. Adding one and assigning back gives a counter that needs no initialisation step. The same shape handles any grouping: sum bytes per client (add a number instead of 1), collect the latest timestamp per host, or keep the longest line per category.

A trap sits next to it. On a normal map, `count[$k]+=1` is a string append, so a counter at 1 becomes "11". Use arithmetic (`$(( ))`) or declare the map with `declare -Ai count`, where every assignment is evaluated as an integer and `+=` really adds.

The second trap is order. A map has no inherent order, so a script that prints the keys straight from `${!count[@]}` produces output that differs between Bash versions and, in some cases, between runs. Sorting the keys makes the output stable and testable. The next level concentrates on exactly that part.

## In real work
Requests per status code, errors per host, logins per user, words per file: "how many of each".

## Going further
You counted and sorted by name. Next: sorting keys numerically, and in reverse.

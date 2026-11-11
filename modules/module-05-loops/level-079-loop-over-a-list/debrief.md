# Debrief: Loop over a List

A `for` loop is a way of saying "do this once per item". The body is written a single time and Bash replays it, changing exactly one thing each round: the loop variable.

## How it works
Bash first splits the words after `in` into a list. Then it repeats: assign the next word to the variable, run everything between `do` and `done`, check whether any words are left. When the list is exhausted, execution continues with the first line after `done`. The variable keeps the last value afterwards, which sometimes surprises people.

Because the list is just words separated by spaces, `for n in a b c` and `for n in $(cat names.txt)` look alike, but the second is fragile when names contain spaces. Later levels show safer ways.

## In real work
Fifty servers, one script: the loop is the difference between ten minutes and a whole afternoon. Fleet checks, patch rollouts and certificate renewals are almost always a `for` around a list of hosts.

## Going further
Typing a list of a hundred numbers would be silly. In the next level, brace ranges like `{1..5}` write the list for you.

# Debrief: Index into It

An array is a numbered list, and `${name[N]}` is how you ask for slot N. The numbering starts at zero, so the first element is `[0]`.

## How it works
The curly braces are not decoration. In `$rack[2]`, Bash expands `$rack` first (which means `${rack[0]}`) and then leaves `[2]` as literal text. Only `${rack[2]}` is read as an element lookup. The same trap explains why `$rack` alone prints just the first element: a bare array name means index 0.

Negative indexes, available since Bash 4.3, count from the end. `[-1]` is the last element, `[-2]` the one before it. They save you from computing the length when you only want the tail.

Reading an index that does not exist is not an error in ordinary use. It simply expands to an empty string. That makes typos in index numbers quiet, so check your output when something prints blank.

## In real work
Positional data shows up everywhere: the first and last line of a file loaded into an array, the newest item in a sorted list, the third column of a split record.

## Going further
The next level expands all elements at once, safely, so you can pass them to commands without losing names that contain spaces.

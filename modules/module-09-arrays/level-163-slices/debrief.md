# Debrief: Slices

A slice is a sub-list: `${arr[@]:start:count}` copies `count` elements beginning at index `start`. If you know substring extraction on strings, this is its list version.

## How it works
Bash walks to the start position, takes up to `count` elements, and expands them as separate words (inside double quotes, one word each). Omit the count to take everything from `start` onwards. Ask for more than exists and you simply get what exists.

Slices are expansions, not operations: they produce words and leave the array alone. To keep the result you assign it to another array, as the answer does with `wave=(...)`.

A few corners. A negative start counts from the end, but writing it literally needs a space, `${arr[@]: -2}`, otherwise `:-` is read as "default value". A variable (`$offset`) avoids that. On sparse arrays, the start refers to the index number, not to the "nth element present", so slicing after an `unset` can surprise you.

## In real work
Batching ("process 50 items at a time"), pagination, dropping a header (`"${lines[@]:1}"`), taking the "top 3" from a sorted list.

## Going further
Slices give you pieces. The next two levels let you visit every element in turn, first by value and then by index.

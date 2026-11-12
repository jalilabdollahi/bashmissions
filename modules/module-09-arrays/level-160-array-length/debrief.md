# Debrief: Array Length

Two different questions share one symbol. `${#arr[@]}` asks "how many elements?", `${#arr[0]}` asks "how many characters in that element?". Mixing them up is the commonest array bug of all.

## How it works
The `#` operator always means length, and what it measures depends on the subscript. With `[@]` (or `[*]`) the target is the list, so you get a count. With a number the target is one element's text. Without any subscript, Bash silently assumes `[0]`, which is why `${#fleet}` looks plausible and still answers the wrong question.

The count is also the basis for loops and guards you will write constantly: `if (( ${#fleet[@]} == 0 ))` means "nothing to do", and `(( i < ${#fleet[@]} ))` is the classic loop limit.

One subtlety for later: the count is the number of elements that are set, not "highest index plus one". After you remove an element from the middle (the next-but-one level), the count goes down by one but the highest index does not.

## In real work
Checking "did the glob match anything?", "did the user pass enough arguments?" and "is the batch empty?" all reduce to the length of an array.

## Going further
Next: how to add elements to the end of an array without having to know its length at all.

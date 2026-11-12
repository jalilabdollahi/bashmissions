# Debrief: Append Items

`arr+=(x)` says "add these elements at the end". It is the natural way to grow a list, because you never need to know how long the list currently is.

## How it works
The `+=` operator on an array assignment does not overwrite; it extends. The words inside the brackets are expanded and added after the highest existing index. Several items at once work too: `pool+=(a b c)` appends three.

The brackets decide the meaning. Without them, `pool+=text` is a string append that modifies the first element, so `pool+=dory` on `(anchovy barracuda)` gives `anchovydory barracuda`. Nothing errors, so you only notice from the output.

Appending in a loop is how most real arrays get filled. Notice that the loop runs in your own shell here because stdin is attached to it directly; had you piped into it, the array would have been filled in a subshell and thrown away (level 94).

## In real work
Collecting results: every host that failed a check, every file older than a week, every line that matched a pattern. You walk the input once and push what you want to keep.

## Going further
Next you will remove an element, and discover that Bash does not renumber the others.

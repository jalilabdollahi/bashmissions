# Debrief: Recursion: Factorial

Recursion means a function calling itself on a smaller version of the problem.
Every recursive function needs two things: a base case that returns without
recursing, and a step that moves toward it. Forget the base case and the
function calls itself until Bash runs out of resources.

Under the hood each call gets its own set of local variables, kept in a stack of
call frames. `factorial 3` waits while `factorial 2` runs, which waits for
`factorial 1`. When the deepest call returns, the answers unwind back up the stack.
That is why `local` is essential: all the calls are alive at once, and each needs
its own `n`.

Here every level of recursion starts a subshell through `$( )`, which is
slow compared with a loop. Bash is not tuned for deep recursion (the default
function nesting limit is high, but each level costs a process). So use recursion
where the data itself is nested: directory trees, nested configuration, tree-shaped
dependency lists.

A helpful habit when you write recursion: first write down the base case, then the
step, then trace a tiny input (like 3) on paper.

Going further: the next level applies this to real nested data: the folders of a
website.

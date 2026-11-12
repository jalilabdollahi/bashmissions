# Debrief: Callbacks by Name

A callback is a piece of behaviour handed to another piece of code, to be run
later. Bash has no function objects, but it does not need them: when Bash
executes a command, the first word is just text that gets looked up as a function,
a built-in or a program. So `"$callback" "$item"` works. The name in the variable
is resolved at the moment of the call, exactly as if you had typed it.

This separates two concerns. `apply_each` knows nothing about capital letters or
lengths; the workers know nothing about loops. You can test each alone, add a new
worker without touching the loop, and reuse `apply_each` in other scripts.

Notes. The callback may be any command, not only your functions: `apply_each
basename a/b c/d` works, too. The names in a `case` act as a whitelist: the user
types a *mode*, and your script chooses the function. Never run a user-supplied
string as a command without a check like that. And `shift` in a function only
affects that function's own arguments.

You will see the pattern in tools such as `xargs`, `find -exec` and in the
test-runner functions of shell test frameworks.

Going further: the next level shows how to call a function inside a `while read`
loop, the other most common shape of per-item work.

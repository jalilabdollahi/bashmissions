# Debrief: Functions in Conditions

`if`, `while`, `&&` and `||` do not evaluate expressions; they run a command and
look at its exit status. `[[ ... ]]` and `test` are just commands that happen to
set a status. Because a function is also a command, you can put it in the same
place, and the readable names do the talking: `if is_empty_file "$f"`.

The rule is: status 0 is "true", anything else is "false". That feels backwards
if you come from other languages, but it is consistent: success is the one
way things go right, failures are many.

A function without `return` gives back the status of the last command it ran,
which is why a function whose whole body is one `[[ ... ]]` works neatly as a
predicate. If the body has several steps, finish with an explicit `return 0` or
`return 1` so you are sure what the caller sees.

You will meet these "predicate" functions all over real scripts: `is_root`,
`port_open`, `has_command git`. Negate with `if ! fn; then`, or chain with
`fn && do_more`.

Going further: a function can also give back *data*, not just a yes or no. That
is the next level.

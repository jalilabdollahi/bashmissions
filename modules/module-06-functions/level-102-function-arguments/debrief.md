# Debrief: Function Arguments

A function behaves like a tiny script: it has its own `$1`, `$2`, `$#` and
`"$@"`. When you call `describe "dory" 12`, Bash temporarily replaces the
positional parameters with those words for the duration of the call, then puts
the script's originals back when the function returns. That is why the same name
`$1` can mean two things in two places without a clash.

The mental model is "a function is a command you wrote". Commands take
arguments, so functions do too. This is also why quoting at the call site
matters: the function receives exactly the words the caller produced after
expansion, nothing more.

One thing that does *not* change is `$0`: inside a function it is still the name
of the script, not of the function. (Bash keeps the function's name in
`FUNCNAME` if you ever need it.)

In real scripts you will see helpers such as `backup_site NAME`, `notify
CHANNEL MESSAGE` or `is_up HOST`, small verbs with explicit inputs.

Going further: so far the function only prints. Next you will learn to hand a
yes/no answer back to the caller.

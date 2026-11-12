# Debrief: Generators with State

Functions in Bash are stateless unless you give them somewhere to keep state.
The somewhere is a variable outside the function. A *generator* is that
pattern with a promise attached: only this function changes that variable.
Callers see a clean interface ("give me the next one") and never the counters.

## Under the hood

Variables are global by default and stay for the life of the shell, so the
array survives every call. The real subtlety is **which shell** runs the
function. A command substitution, a pipe stage and a `( )` group each run in a
forked copy; they can read the counters but their changes die with them.
This is why the result is passed in `REPLY` instead of printed: a printing
function could only be captured with `$( )`, which is exactly the thing that
would lose the update. `printf -v` is the cheap, fork-free way to format into a
variable.

## Design notes

Validation lives in one helper used by both paths (`gen_next` and `reset`),
so the error message cannot drift. The case statement keeps the formats
visible in one place, and a new kind means one array entry and one line.

## In real work

Unique ids in a run, numbered output files, round-robin pickers ("next
server"), and test fixtures all need a counter that survives calls. When the
number must survive between runs or processes, move the state to a file and
lock it, or use a proper tool.

## Going further

The same idea works for reading a file: the state is "how far have I got".
Next, an iterator over lines.

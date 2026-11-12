# Debrief: The Call Stack

Every time a function is called, Bash remembers who called it. That memory is the
call stack, and Bash exposes it as arrays: `FUNCNAME` (names, innermost first),
`BASH_LINENO` (the line each frame was called from) and `BASH_SOURCE` (the file
each frame lives in; the next level uses it). All three share one indexing:
entry `i` describes the same frame.

The mental model is a stack of plates. `nightly` calls `rotate_logs`, which calls
`compress`, which calls `stack`: four plates, the newest on top. When
`stack` finishes it is removed, and the arrays shrink. They are only meaningful
inside functions; at the top level of a script `FUNCNAME` has just the
pseudo-entry `main`, which is why we stop before it.

Two details trip up everybody. First, off-by-one: `BASH_LINENO[i]` is the line
where `FUNCNAME[i]` was *called*, not where `FUNCNAME[i-1]` was. Second, the
arrays are only populated for function calls, so a trace helper that lives inside
a function must skip its own frame.

Where it shows up: the "traceback" of an uncaught error in a Bash library, test
frameworks that print where an assertion failed, and `die` helpers that report
the caller rather than themselves.

Going further: functions often live in other files. The next level uses
`BASH_SOURCE` to tell where a function was defined.

# Debrief: An Iterator over Lines

An iterator separates *consuming* data from *deciding what to do with it*. The
loop does not have to know how lines are stored, only that `next_line` gives
another one or says it is done. The state of the traversal lives in one
number, `cursor`, which you can print, save, or move back.

## Under the hood

Nothing here is a special Bash feature. It is a global array, a global index,
and a function that changes the index and sets `LINE`. Two choices make it
pleasant to use. The result travels in a variable so the iterator runs in the
main shell and its cursor update sticks (a `$(next_line)` would advance a copy
and get stuck on line one forever). And the end of data is signalled with an
exit status, so `while next_line; do` and `next_line || break` read naturally.

The cursor doubles as line bookkeeping: because it is incremented *after*
handing a line out, its value right after the call is the 1-based line
number. Off-by-one questions like this are best decided once and written next
to the code.

## In real work

Formats where one logical record spans several lines are everywhere: PEM
certificates, `/etc/passwd`-style stanzas, mail headers, hand-kept config
blocks. Parsers for them almost always have this shape: next token, and a
position.

## Going further

Instead of pulling data, code can be pushed: handlers register for something
that happens and get called when it does. Next, event handlers.

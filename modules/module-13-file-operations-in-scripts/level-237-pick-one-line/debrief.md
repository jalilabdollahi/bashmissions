# Debrief: Pick One Line

## What you learned

`sed` is a line-oriented editor with a simple grammar: an optional
*address* (which lines) followed by a *command* (what to do). `-n` means
"print nothing unless I say so", and `Np` means "print line N". Together
they select a single line from a file of any size, without reading it into
a variable.

## Under the hood

`sed` streams through the file once, keeping a line counter. For each line
it checks whether the counter matches the address, and runs the command if
so. A line number beyond the end never matches, which is why the output is
silently empty instead of an error: you must decide what "empty" means for
your script.

Because the day is pasted into the sed *program*, it is code, not data.
That is why the script validates it as digits first. A stray `;` or letter
there would change what sed does.

## In real work

Pulling the header row from a CSV (`1p`), the third line of a command's
output, or a single line out of a log by number found with `grep -n`: all of
these are `sed -n 'Np'`.

## Going further

Instead of one line, how many lines are there in total, and how many words?
Next: `wc`, with a portability trap.

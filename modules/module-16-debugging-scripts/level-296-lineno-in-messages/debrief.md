# Debrief: LINENO in Messages

`$LINENO` is one of Bash's built-in "dynamic" variables. You never assign it:
before it runs each command, the shell sets it to the line number of that command
in the script file. Put it inside a string and you get an address with the
message, for free, always correct, even after the file is edited.

Why it earns its keep: a message like "file is empty" tells a human what went
wrong; a message like "line 12: file is empty" tells them where to look. With
a few dozen checks in a script, that is the difference between a one-minute fix
and a hunt through the source. It also lets you match a log entry to a version of
the script in version control.

There are subtleties worth knowing. LINENO counts lines in the file the code was
read from, so inside a function it reports the line inside the function body.
That is exactly right for the echo, but it is why a generic `die` helper cannot
tell you where it was *called* from: it reports its own line. Inside a command
substitution or after line continuations with a backslash, the number can point
at the first line of a multi-line command.

The same variable powers custom trace prefixes (`PS4`) and ERR traps, as you have
seen and will see again.

Going further: when the failing code is in a function called from a function
called from main, you want the whole chain. That is the call stack, up next.

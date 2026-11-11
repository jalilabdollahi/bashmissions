# Debrief: Return a Status

`return` in a shell function does not return a value; it returns an *exit
status*, a number from 0 to 255. This is the same mechanism that every command
uses: `grep` returns 1 when it finds nothing, `test` returns 0 for true. A
function is just another command, so it speaks the same language.

Convention: 0 is success, non-zero is failure or a special condition. A function
can use different non-zero numbers to say what went wrong, just as `grep` uses 1
for "no match" and 2 for "error".

The result of the most recent command is available in `$?`. It is overwritten
immediately, so a good habit is to save it in a variable on the very next line,
or to test it directly (the next level shows how). If you `return` with no number
the function hands back the status of its last command.

Real scripts use this everywhere: `is_port_open`, `file_is_stale`,
`user_exists`. Their callers never need to look at `$?` at all.

Going further: instead of `code=$?`, you can put the function call right inside an
`if`. That is the next level, and it makes status-returning functions feel natural.

# Debrief: sed In Place with Backup

Everything so far was a filter: input in, output out, original untouched. That
is safe, but sometimes the job is to change the file. `sed -i` does it, and
what it does underneath is worth knowing. It does not edit bytes in the
original. It reads the file, writes the result to a new temporary file, and swaps
the two, so a crash in the middle leaves the original intact.

The risk with an in-place edit is that the change is permanent. A wrong pattern,
a missing `g`, or an unexpected special character in the replacement silently
rewrites a production config. A backup suffix turns a disaster into a `mv`.
That is why this course always writes `-i.bak`, and the portability argument
(GNU versus BSD) just happens to point the same way.

Notice also what the script prints. A tool that changes files should say
what it changed, in one line that a human or a log can read. Keeping the
output simple makes the script easy to call from other scripts.

Going further: so far, text came from one file at a time. The next levels
put files side by side: `paste` joins lines, `join` matches them by a key.

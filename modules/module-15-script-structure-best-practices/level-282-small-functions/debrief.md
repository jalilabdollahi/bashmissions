# Debrief: Small Functions

A function should do one job that you can name in a few words, and its name should
say which. That is not style for its own sake. When a rule has a name, you can find it,
change it in one place, call it from somewhere new, and test it without running the
whole script. `main` becomes a table of contents: read lines, skip blanks, normalise,
validate, format.

Notice the two ways a function can answer. A function that *produces* something
prints it, and the caller captures the text with `$(...)`. A function that *decides*
something returns a status: 0 for yes, non-zero for no, because in shell every `if` is
a status test. `is_port "$p"` can sit directly after `if` or `||`, and nothing is
printed that someone has to parse. Mixing the two (printing "yes" and then testing the
text) is the classic anti-pattern.

Behind the scenes, calling a function is cheap (no new process) except when you use
`$(...)`, which forks a subshell. For per-line work on large files, that cost is
noticeable, so for tight loops prefer status-returning helpers or `printf -v`.

Going further: once every concern is a function, arguments are the next thing to
standardise. Level 283 builds a complete option parser around the same ideas.

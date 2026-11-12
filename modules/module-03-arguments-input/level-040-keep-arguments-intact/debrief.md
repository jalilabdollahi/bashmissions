# Debrief: Keep Arguments Intact

There are two separate things that happen to a word in Bash: it is *expanded*
(variables replaced), and then it is *split* on whitespace and globbed unless it
is quoted. Unquoted `$@` is expanded and then split again, so every argument that
contained a space turns into several. `"$@"` is the exception to the rule that
quotes make one word: it produces one word per argument, preserving each exactly.

Think of it as a sealed envelope per argument. `"$@"` forwards the envelopes;
`$@` rips them open and re-sorts the loose paper.

In real work this matters every time a script wraps another command: a deploy
script that forwards flags to a build tool, an alias that adds `--verbose`, a
cron helper that logs and then runs its arguments. The pattern `command "$@"` is
among the most common lines in professional Bash.

Going further: if a script receives filenames, a single unquoted `$@` is how
"my file has a space in its name" bugs are born, and why a later module drills
quoting hard.

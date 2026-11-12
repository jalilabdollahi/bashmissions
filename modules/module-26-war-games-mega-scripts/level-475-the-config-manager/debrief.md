# Debrief: The Config Manager

"Twelve-factor" apps, Kubernetes ConfigMaps, `git config`, `systemd` drop-ins: all of them merge layers, and
all of them have been bitten by the same question: *where did this value come from?* The answer you built, a
`source` recorded next to every value, costs one array and removes hours of guessing. A fixed, documented
precedence (defaults, files, environment, command line) is the other half: people can reason about it.

Validation against a **schema** moves mistakes from runtime to startup. Unknown keys are errors, not silently
ignored, so a typo cannot turn into a missing setting. Types are checked once on the merged value, booleans are
normalised, and every problem is reported in one run. Notice also the quiet careful bits: `${var+set}` and
`[[ -v name ]]` tell "empty" from "unset", `${!name}` reads a variable by a computed name, and secrets are masked
at the single place that prints values, so no future command can forget to do it.

Exporting in three encodings is a reminder that data and its representation are different things: the same
value needs no quoting in an env file, single quotes for a shell and escapes for JSON.

Going further: the next level turns from reading state to managing work: a FIFO job queue with workers.

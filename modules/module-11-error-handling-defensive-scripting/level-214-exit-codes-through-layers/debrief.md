# Debrief: Exit Codes Through Layers

An exit status is a single number that has to survive every layer between the
command that produced it and the person or system that finally reads it. In
real scripts there are many layers: a function inside a pipeline inside a wrapper
inside a cron job. Each layer can drop the number without anybody noticing, and the
dashboard then shows green over a red failure.

The four hand-offs from this level are worth memorising. A **pipeline** reports its
last stage unless you use `pipefail` or read `PIPESTATUS`. A **function** reports
what you `return`, or else the status of its last command. A **list** like
`a || exit $?` keeps `$?` for the right-hand side. And `exit` with no number
re-uses the status of the previous command. Whenever you write a wrapper, ask at each
boundary: "what number leaves here?"

This also closes the module's arc. You started by reading `$?` once. You added guards
(`||`), then `set -euo pipefail`, then traps for cleanup and signals, retries and
time limits, and finally messages and codes that other people and programs can
act on. Together they turn Theo's optimistic script into one that fails early,
loudly, specifically and tidily, which is what "failing safely" means.

Going further: the next module turns from stopping on problems to finding patterns
in text with regular expressions.

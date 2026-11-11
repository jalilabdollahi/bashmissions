# Debrief: if and else

`else` guarantees that one of two paths runs. That matters in operations: a
script that prints nothing when things are fine is ambiguous, because silence
could mean "healthy" or "never ran". A report that answers in both cases can be
trusted.

## Under the hood

The mental model: `if` runs a command and checks its exit status. Zero means
success, which is "true". Anything else is "false". `[[ ... ]]` is one such
command, but any program works, and that is why `if grep -q ...` is so common in
real scripts. Programs are written so that their exit status answers a question:
grep says "found it", `diff` says "same", `ping` says "reachable".

Because `if` is a condition context, `set -e` does not kill the script when the
tested command fails. A failing test is a normal answer, not an error.

## Where it shows up

Health checks ("is the service answering?"), installers ("is the config already
there?"), and cron jobs that must report both success and failure all use this
shape.

## Going further

Two branches cover yes and no. When the world has more than two answers, such as
healthy, slow, or down, you need a ladder of choices. That is the next level.

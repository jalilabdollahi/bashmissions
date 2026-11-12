# Debrief: Silence Is Golden

## What you learned

Output is optional; the exit status is the real answer. When you only care
whether something worked, run it in an `if` and discard its streams with
`/dev/null`.

## Under the hood

`/dev/null` is a device file provided by the kernel. Every write succeeds
instantly and is forgotten, so a program cannot even tell it is being
ignored. It costs nothing, which is why it is safe to use on huge outputs.

The pattern `> /dev/null 2>&1` relies on last level's order rule: stdout goes
to the black hole first, then stderr copies it. Many scripts also use
`2> /dev/null` alone when they only want to hide errors, for example while
probing for an optional file.

## In real work

Availability checks, "is this command installed?" tests, health probes inside
cron, and any place where a tool's output would bury your own messages.

## Going further

Be careful with silence: hiding stderr also hides real errors. A good script
silences deliberately and reports its own message when something fails.
Next, we reverse direction and feed files into commands with `<`.

# Debrief: Your First if

Until now every script ran the same lines in the same order. An `if` gives a
script a fork in the road: a question is asked, and the answer decides whether
a block of commands runs at all.

## Under the hood

`if` does not look at text; it runs a command and looks at that command's exit
status. Status 0 means success, which counts as "true", and anything else counts
as "false". `[[ $target == prod ]]` is such a command: it exits 0 when the two
strings match and 1 when they do not. That is why the layout matters. `[[` is a
word, so it needs a space after it and `]]` needs a space before it.

The semicolon before `then` simply ends the test command; you can put `then`
on its own line instead and skip the semicolon.

## Where it shows up

Every deploy tool, backup script and installer starts with checks like this:
"is this production?", "was a flag given?", "did the last step work?". The
on-call runbook at Lanternfish is just a list of if-this-then-that sentences,
and you can now turn any of them into code.

## Going further

Right now the script says nothing when the answer is "no". In the next level you
add an `else` so both outcomes speak up.

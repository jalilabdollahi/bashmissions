# Debrief: Safe Dynamic Calls

Last level you asked "does it exist?". The question here is different: "is it
allowed?". Existence is a fact about the script; permission is a decision. The
`do_wipe` function exists and works perfectly, and that is exactly why a
check that only looks for existence would be a vulnerability.

## The model

Treat any value that comes from outside the script as *data that picks from a
menu you wrote*, never as *code*. The menu is the allow-list. Anything
not on it is refused, whatever it looks like. Allow-lists beat deny-lists
because you do not need to think of every bad input in advance, only list the
good ones.

## Under the hood

`"do_$action" "$target"` is safe only because of what happens before it: by
the time Bash expands the name, `$action` is one of three known words. The
expansion yields a single word, since it is quoted, and no part of the input
is ever parsed as shell syntax: `restart;` stays one word with a semicolon
in it, and gets refused as unknown. That is also why `eval` is absent: eval
would re-parse the text and give the semicolon its power back.

Exact matching matters. Patterns (`restart*`), prefix tests and case-insensitive
compares widen the list in ways nobody planned.

## In real work

Chat bots, webhooks, CI "slash commands", ticket-driven automation: all
of them map text to actions. The allow-list belongs in the script, in version
control, reviewed by someone paranoid for a living.

## Going further

Functions often have to hand their arguments on to another command without
changing them. Next: `"$@"` pass-through.

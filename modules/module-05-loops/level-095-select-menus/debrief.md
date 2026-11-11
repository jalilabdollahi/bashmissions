# Debrief: select Menus

`select` is a loop that is driven by a person (or a pipe) instead of by a list. The list becomes the menu, and each round runs once per choice made.

## How it works
Each time round, `select` prints the numbered items and the prompt held in the variable `PS3` to stderr, reads one line from stdin, and sets two variables. The loop variable gets the item matching the number, or an empty string when the input is not a valid choice. `REPLY` always gets the exact text typed, which is how you can tell "9" from "abc" when both are invalid.

Nothing ever ends a `select` loop except `break`, `exit`, `return` or end of input. That is a common source of surprise: the body runs, and the menu simply comes back. Make sure one of the choices leads out.

Because the menu is on stderr and the results on stdout, you can capture or pipe the output of a menu script without capturing the menu itself. It also means tests can feed answers on stdin and still read your messages cleanly.

A `case` on the loop variable is the natural partner: one branch per item, plus one for the empty case.

## In real work
Install wizards, "which environment do you want to deploy to", runbook helpers for people who should not type server names.

## Going further
Back to automation. Level 96 builds a schedule of delays that grow each time, the way retries should.

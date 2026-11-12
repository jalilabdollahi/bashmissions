# Debrief: Quote Your Variables

## What you learned
A `$variable` without quotes is not "the value". It is the value **re-parsed** by the shell: cut into words, then glob-matched. Double quotes say "this is one word, keep it as is".

## Under the hood
Bash expands a command line in stages. After it substitutes `$CUSTOMER`, two more stages run on the unquoted result: word splitting (on whitespace) and pathname expansion (`*`, `?`, `[...]`). Quoting hides the result from both stages. This is why a single missing pair of quotes can make a script work on every test machine and fail on the one customer whose name has a space.

It also matters for safety: a value that is split or globbed can turn into extra arguments you never intended.

## In real work
Quote by default. The few cases where you want splitting are rare and deliberate. Many shell linters exist mainly to flag unquoted variables.

## Going further
Quotes also help when you build a longer text out of pieces. That is the next level: gluing strings together.

# Debrief: Server Profile Card

## What you learned
You combined the whole module: assignment, braces, quoting, captured output, `readonly`, integers, defaults and a required setting. Notice the shape of the script: validate and resolve inputs at the top, then produce output at the bottom from variables only.

## Under the hood
Nothing new happens here. Bash expands each variable or `${...}` form just before running the command that contains it, left to right, line by line. The here-document is expanded like double-quoted text. Because every decision was made in variables beforehand, the card is easy to read and the logic is easy to test with different environment settings, which is exactly what the checks did.

## In real work
Almost every automation script follows this layout: read the environment, supply defaults, refuse bad input, do the work, report. Treat the top of a script as its contract with whoever calls it.

## Going further
Everything this card needs came from the environment and one fixed file. In module 3 your scripts will receive arguments and read input typed by users or piped in - the same variables, filled by new sources.

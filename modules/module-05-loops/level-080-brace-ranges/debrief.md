# Debrief: Brace Ranges

A brace range is not a loop feature. It is a text generator that Bash runs before anything else on the line. `{08..12}` is replaced by the five words `08 09 10 11 12`, and the `for` loop simply receives that list.

## How it works
Brace expansion happens at the very start of parsing, before variables are expanded. That explains the famous limitation: `{1..$n}` does not work, because when the braces are processed `$n` is still just the text `$n`. Ranges also run backwards (`{5..1}`) and work on letters (`{a..e}`).

A leading zero on either end of the range turns on padding, so `{01..10}` gives `01 02 ... 10`. Without the zero you get `1 2 ... 10`, which sorts and aligns badly in file names.

Braces can also be combined with text: `mkdir rack-{08..12}` creates five directories in one command, no loop needed.

## In real work
Numbered hosts (`web01` to `web40`), month folders, port ranges and log rotation names all follow a counting pattern that braces express in a few characters.

## Going further
When the end of the range lives in a variable, you need a loop that counts on its own. Level 81 introduces the C-style `for`.

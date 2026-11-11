# Debrief: Single Quotes Are Literal

Bash has two kinds of quoting with two different promises. Double quotes say "keep this together, but you may still substitute". Single quotes say "this is raw text, do not touch it".

## How it works
Before running a command, Bash performs expansions: `$VAR` becomes a value, `$(cmd)` becomes output, and a few more you will meet later. Double quotes allow most of them. Single quotes block all of them, so the characters between them reach the command exactly as typed.

That is also why a variable that does not exist silently turns into nothing, as `$5` did in the starter. No error, just a vanished piece of text.

## In real work
Single quotes are the safe default for fixed text, especially patterns, awk and sed programs, and messages that talk about variables instead of using them. Reach for double quotes only when you want the substitution.

## Going further
Next you will leave `echo` for `printf`, which gives you precise control over line breaks and tabs.

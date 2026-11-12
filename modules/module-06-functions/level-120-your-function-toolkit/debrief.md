# Debrief: Your Function Toolkit

Look at the main flow of your script: five lines, each reading like English. That
is the payoff of this whole module. The details live in small named functions;
the plan is visible at a glance, and each piece can be tried alone in a terminal
(`slugify "Gull & Anchor Pub"`).

You have now used every channel a function has:

- arguments in (`$1`, `$2`, defaults with `:-`);
- exit status out (`valid_quota`, used as an `if` condition);
- stdout out (`slugify`, `tier_for`, captured with `$( )`);
- stderr for messages (`log`, `die`);
- `exit` for ending the script, `return` for ending only the function;
- `local` to keep helpers from leaking into one another.

Design rules of thumb: one job per function; name it with a verb or a question
(`slugify`, `valid_quota`); keep results on stdout and commentary on stderr; check
inputs at the top with guard clauses; and define everything before the first
call. When the helpers prove useful beyond one script, move them into a library
and `source` it.

Going further: the next module takes the text apart in a different way: string
manipulation with `${var#...}`, `${var%...}` and `${var/old/new}`, no external tools
needed. Several of the helpers you wrote with `tr` and `sed` have shorter forms
there.

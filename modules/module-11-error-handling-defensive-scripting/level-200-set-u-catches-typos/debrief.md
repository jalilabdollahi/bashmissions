# Debrief: set -u Catches Typos

In Bash, a variable that was never assigned and a variable holding an empty
string look identical when expanded. So a typo does not produce an error; it
produces an empty value, and the empty value flows into the next command. That
is how `rm -rf "$DIR/"*` turns into `rm -rf /*`.

`set -u` (also written `set -o nounset`) changes the rule: expanding an unset
variable is a fatal error that names the variable and the line. It converts a
silent, potentially destructive mistake into a loud one at the earliest possible
moment. It also catches missing inputs: a deploy script run without its
environment dies on the first use rather than deploying to nowhere.

The price is that you must say what you mean about optional values.
`${VAR:-default}` is the "may be missing" spelling, `${VAR:?message}` is the
"must be present" spelling, and `${VAR-}` gives an empty string without an error.

Note that `set -u` only reacts to *unset* names. A variable set to an empty
string passes, so important paths still deserve a `[[ -n $DIR ]]` check.

Going further: `set -e` and `set -u` are two of the three switches in the usual
"strict mode". The third hides in pipelines and is the subject of the next level.

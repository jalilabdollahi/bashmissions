# Debrief: Optional Second Argument

`${var:-default}` is *parameter expansion*, a family of small tools built into
Bash for adjusting a variable at the moment it is used. This one means "if this
is missing or empty, here is the fallback". The variable itself is not changed,
only the value that appears in this spot. (Its sibling `${var:=default}` also
assigns it.)

It is the cleanest way to make an argument optional, because it removes the need
for an `if` and stays safe under `set -u`: an unset `$2` normally aborts the
script, but `${2:-...}` is allowed to be unset.

Real scripts use it constantly for sensible defaults: `${EDITOR:-vi}`,
`${PORT:-8080}`, `${1:-.}` for "the current directory unless told otherwise".
Defaults like that are a kindness to whoever runs the script next.

Going further: arguments are one way in. The next levels teach the other one,
reading what a user types or pipes into the script (`read`).

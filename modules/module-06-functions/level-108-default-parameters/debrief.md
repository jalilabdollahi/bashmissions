# Debrief: Default Parameters

Real functions are rarely called with every argument. A good helper has sensible
defaults, so the common call is short and the rare call can override. In Bash
the tool for this is the fallback expansion `${param:-default}`.

There is a small family: `${p:-x}` uses `x` when `p` is unset or empty;
`${p-x}` only when unset; `${p:=x}` also assigns the default back to `p`; and
`${p:?message}` aborts with an error when `p` is missing, which is useful when an
argument is mandatory. For this course the `:-` form covers most needs.

Positional parameters work the same as named ones, so
`${1:-30}` is just "the first argument, or 30". This also matters for `set -u`
(treat unset variables as errors): bare `$1` on a call with no arguments would
abort the script, whereas `${1:-30}` is explicitly allowed to be absent.

Real use: `backup_dir=${1:-/var/backups}`, `port=${2:-8080}`, `log_level=${LOG_LEVEL:-info}`,
the last one is the same trick applied to the environment, which you will meet again
in the logging helper.

Going further: sometimes a missing argument should not be defaulted but rejected.
That is the next level: guard clauses.

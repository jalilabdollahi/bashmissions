# Debrief: Constants Block

A constants block answers a reviewer's first question, "what can I tune here?", in
ten lines at the top of the file. It also turns configuration into names: `KEEP_DAYS`
explains itself, `14` does not, and changing it means one edit instead of a hunt that
misses one copy.

`readonly` marks a variable as locked for the rest of the shell's life. Reassigning
it, or unsetting it, is an error (and under `set -e` the script stops). Notice what
this level separates: a constant is chosen by the script's author, while a setting is
chosen by the caller. If you wanted the caller to decide, you would write
`${BACKUP_ROOT:-/srv/backups}`, which is the next-but-one level's topic. Mixing the
two by accident, as the starter did, hands your configuration to anyone who can set
an environment variable.

`readonly` is local to this shell process. It is not inherited by child scripts,
and it does not stop another program from reading the file. It is a guard against
your own mistakes and against the environment, not a security boundary.

Going further: some values do vary per run, but you want them validated and
documented. Level 285 builds that: settings from the environment, with checks.

# Debrief: POSIX-Friendly Code

`/bin/sh` is not bash. On Debian and Ubuntu it is dash, a small fast shell that
implements the POSIX standard and little else; on Alpine it is busybox ash; on macOS
it is bash 3.2 in compatibility mode. Anything beyond the standard (`[[ ]]`,
arrays, `${v,,}`, `(( ))`, `==`, `local` in strict terms) is a *bashism*, and it
fails there, usually with a confusing message about a "bad substitution" or an
"unexpected operator".

Choosing is a trade-off. Bash gives you friendlier syntax and safer string handling.
POSIX sh gives you reach: install scripts, Docker entrypoints, boot-time code and
cron lines on odd systems. A good rule is to decide per script, write the shebang that
tells the truth (`#!/bin/sh` only if the file really is POSIX), and test under the
shell you claim. The tools of the trade are small: `[ ]` with quoted variables, `case`
for pattern matching, `$(( ))` for arithmetic, `tr`/`sed`/`awk` for text, `printf`
for output, and `command -v` instead of `which`.

The translation is also instructive because it shows what the bashisms were doing.
`[[ ]]` is a test that does not word-split; in `[ ]` you earn that by quoting.
`case` is pattern matching you already had.

Going further: when a script both works and is documented, the last polish is making it
describe itself. Level 290 lets a script print its own help from its header.

# Debrief: grep -E Filters

You learned a language in `[[ =~ ]]`; now it shows up in the most-used text
tool on any Unix system. `grep` reads a file (or stdin), tests every line
against a pattern and prints the lines that match. With `-E` the pattern is the
POSIX extended regex you already know, so everything from the last levels
(classes, quantifiers, alternation, anchors) works unchanged.

The difference to `[[ =~ ]]` is the *unit of work*. In Bash you test one string
that is already in a variable. `grep` runs through a whole stream by itself,
which is why it beats a Bash loop for large files: one process, no per-line
overhead. Choose Bash `=~` when you need the pieces in variables, and `grep` when
you want to select lines.

The second lesson is about exit codes. `grep` uses its status to answer "did you
find something?": 0 for yes, 1 for no. That makes `if grep -q ...; then` natural
(`-q` is quiet), but it also means a harmless "no matches" looks like a failure
to `set -e` and `pipefail`. When "nothing found" is a legitimate result, say so
explicitly with `|| true`, or test the status yourself.

Finally, precision pays: surrounding the codes with spaces is what keeps
`/v429/` and a size of `4011` out of the report. Patterns that are slightly too
loose produce confident, wrong reports.

Going further: grep can print only the part that matched, which is the next level.

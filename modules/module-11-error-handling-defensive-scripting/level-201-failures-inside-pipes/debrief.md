# Debrief: Failures Inside Pipes

A pipeline runs all its commands at the same time, connected by pipes, and the
shell must squeeze their several exit statuses into one. The historical rule is
to keep only the last: `cmd1 | cmd2 | cmd3` succeeds if `cmd3` does. The
earlier commands can crash and nobody is told. Because the usual last stages
(`sort`, `head`, `tee`, `wc`) rarely fail, most pipelines in the world are
quietly unmonitored.

`set -o pipefail` replaces the rule: the status is that of the right-most stage
that failed, and 0 only if all stages were fine. The first stage in a pipe is
typically the one doing the real work (downloading, reading a database), so this
is the one you most want to hear about.

Two things to remember. First, a truncated stream still looks like valid input
to the next stage, which is why the corrupted data from the half-finished
download reached the summary file in the first place. Second, pipefail has its own
corner: `grep` exits 1 for "no matches", so `grep x file | wc -l` now "fails"
on a file without matches. Know which stages may legitimately return non-zero.

Going further: pipefail is one of three switches. The next level puts
`set -e`, `set -u` and pipefail together.

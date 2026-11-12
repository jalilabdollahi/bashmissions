# Debrief: Heartbeat Freshness

The nastiest failures are the quiet ones. A crashed process is easy to notice,
but a job stuck in a loop or waiting on a dead network connection still
"exists". The remedy is to ask the job to prove it is alive *regularly*: after
each cycle it updates a heartbeat file, and anyone can then judge it by that
file's age. This pattern is called a dead man's switch, and it is the same idea
behind systemd watchdogs and monitoring services such as Healthchecks.

Every file carries a modification time (mtime) that the file system updates
whenever its contents change, and `touch` updates it on demand. `[[ a -nt b ]]`
and `[[ a -ot b ]]` compare two mtimes without any date arithmetic, and that is
the point: instead of converting times to numbers, compare against a reference
file that *represents* a time. Having "now" supplied from outside the script,
here by the stamp, makes it easy to test and free of time-zone confusion.

The order of checks matters: existence first, then age, because `-ot` on a
missing file is false and would label a job that never started as fresh.
Having three outcomes (fresh, stale, missing) rather than two helps whoever
reads the alert.

Going further: a heartbeat measures silence. The next level measures noise: how
many errors per minute a log is producing.

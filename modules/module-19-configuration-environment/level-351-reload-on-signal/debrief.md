# Debrief: Reload on Signal

The mental model: **a running process can be told things.** Signals are the
operating system's way of tapping a process on the shoulder, and `trap` is how a
script says what to do when tapped. `SIGHUP` has become the convention for "re-read
your configuration": `nginx -s reload`, `systemctl reload`, `rsyslog`, `sshd` and
`haproxy` all rely on it, and it lets you change settings without dropping a single
connection or buffered line.

The signal is the easy part. The craft is in reloading safely. Two habits matter.
First, one code path: the start-up load and the reload call the same function, so
they cannot disagree about what a valid file is. Second, stage then commit: read the
new value into a temporary variable, validate it, and only then overwrite the live
one. If an administrator saves a half-typed file, a good daemon logs a complaint and
keeps serving with the previous settings instead of crashing at 3 a.m.

Under the hood, Bash does not run a trap in the middle of an external command; it
waits until the current command finishes. With `kill -HUP $$` the signal is
delivered to the script itself, and the handler runs right after `kill` returns,
which is why the output is deterministic.

Going further: every layer so far (defaults, file, environment, flags, reloads)
feeds one final set of values. The next level shows them all, sorted, with where
each came from.

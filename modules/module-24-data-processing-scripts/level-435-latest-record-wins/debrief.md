# Debrief: Latest Record Wins

The mental model: **an append-only log holds history; "current state" is a
reduction of it.** Systems that only ever append are simple and safe (no update
can lose data), but someone has to fold the history into a snapshot. The fold
here is "for each key, keep the record with the greatest timestamp". It needs
one pass and one stored row per key, no sorting of the input, and it does not care
how the writers interleaved their lines. The same pattern builds the latest
price list, the last known status of each host, and the most recent login per
user.

Three decisions make the fold trustworthy. The *key* must be normalised
(lowercase email) or one person becomes two. The *order* must be defined by
data (the timestamp), not by position in the file, since the three systems flush
at different times. And the *tie* needs a rule (later line wins) or the answer
depends on the sort. Writing them down in the objective is part of the job.

The `read` trick is worth keeping: when one open file is shared by a `read` and
the command after it, the command continues exactly where `read` stopped.
It lets you treat a header separately from the data without temporary files.

Timestamps are compared as text here, which relies on the ISO shape being
exactly right, so the shape is checked and violations are reported rather than
guessed at.

Going further: the last level of the module combines these ideas under a
constraint: a transform that runs on unlimited input without temporary files
and with constant memory.

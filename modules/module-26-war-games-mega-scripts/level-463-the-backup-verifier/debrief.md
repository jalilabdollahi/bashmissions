# Debrief: The Backup Verifier

A backup is only an *intention* until somebody restores it. The verifier turns that
intention into evidence, and the shape of the script is a good template for any
validation job: select the items, run a list of checks ordered from cheapest to most
expensive, stop at the first failure, and report **why** in words an on-call person can
act on. Each check removes one family of problems: no manifest, damaged container, hostile
content, wrong content, unexpected content.

Two details are worth carrying forward. Listing before extracting (`tar -tzf`) is a security
habit, not just an efficiency one, because archive entries are untrusted input and
`../../etc/cron.d/x` is a legal file name. And a scratch directory that a `trap` always removes
means the tool can be run from cron every night without slowly filling a disk, even when a
restore dies half-way.

The verdict also matters: exit 2 means "some system has no recoverable backup in the window"
and is worth waking someone for; exit 1 means "something failed but you still have a good
copy", which can wait until morning. That distinction is the whole point of checking several
generations.

Going further: the next level reads another kind of schedule, crontabs, and asks which jobs
will collide.

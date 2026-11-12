# Debrief: The Incident Responder

"It fixed itself" is only acceptable if you kept the evidence. The responder is built from
patterns that every automated reaction needs. A **trigger** (a rule over a metric) decides
*when*. A **damper** (the cooldown) prevents the reaction from becoming a problem of its
own: an alarm that fires every minute for an hour would otherwise write sixty snapshots and
fill the disk you were investigating. A **transactional write** (temp directory then `mv`)
guarantees that anything named `INC-0007-...` is complete. And **retention** keeps the tool
sustainable.

Mechanically the level is a reminder of how Bash handles numbers and failure. Integers live in
`(( ))`, decimals need awk. A failing collector must not stop the snapshot, so it is tested in
an `if` instead of being left to `set -e`. A trap with a guard variable cleans up exactly the
unfinished work and nothing else. Injectable time (`NOW`) is not just for tests: it is how you
reproduce "what would the script have done at 03:14?" while debugging.

Real incident tooling (PagerDuty runbook automation, `sosreport`, kube debug collectors) follows
the same shape: detect, rate-limit, collect, store, prune.

Going further: the next mission moves from reacting on one server to controlling a change across
three environments, with gates that must pass before a promotion.

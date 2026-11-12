# Debrief: The API Poller

The interesting part of monitoring is not detecting a failure, it is deciding *when
to bother a human*. Two ideas from this level appear in every serious alerting
system. **Hysteresis**: require the evidence to persist before you change your mind,
so noise does not turn into pages. **Durable delivery**: treat the alert as data
that must reach its destination, so you keep it until the receiver acknowledges it.

Mechanically, the poller is a state machine whose state is a one-line file. Each run is
stateless code plus remembered state: read, decide, write back. That is exactly how cron
jobs, CI pollers and Kubernetes controllers work: they compare the observed world to the
remembered one and act only on the difference. Writing the state last, after the
action, and replacing files with `mv` rather than editing in place, keeps a crash
from corrupting it.

Practical lessons: `curl --fail` is what turns an HTTP error page into a failure you can
act on, `sed` can stand in for `jq` for simple extraction, and "unreachable" is a status
like any other, not an exception.

Going further: the next mission also deals with data you cannot trust: backups that look
fine until you try to restore them.

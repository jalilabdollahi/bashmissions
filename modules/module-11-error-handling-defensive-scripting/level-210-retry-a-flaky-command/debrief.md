# Debrief: Retry a Flaky Command

Some failures are transient: a dropped connection, a busy server, a lock held for
a second. Trying again is the right response, and it is the reason experienced
operators put a retry in front of network calls. But a retry loop is also a way to
turn a short outage into a permanent hang, so it needs two properties: it must be
*bounded*, and it must *pause*.

Bounded means a counter and a ceiling written where you can see them. Without one,
the night the CDN is truly down your script spins forever, hammering the service
and holding its lock. Pausing gives the other side time to recover; sleeping after
the last failure would only delay the bad news, so we skip it.

Notice how the command appears: as an `if` condition. That is the idiom that makes
a failure a normal, handled event even under `set -e`, a point you met at the start
of the module. Notice also the different exits: success leaves at once with 0,
and exhaustion leaves with a non-zero code and a message, so the caller knows it
was not a pass.

Retry only what is safe to repeat. A read or an idempotent upload is fine;
"charge the customer" is not. And retry only transient errors: a
config that is broken (code 4 in the last-but-two level) will fail the same way
ten times.

Going further: a command can also hang instead of failing. The next level puts a
time limit on a job.

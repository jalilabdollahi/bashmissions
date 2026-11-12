# Debrief: Deploy with a Health Gate

The mental model: **never wait without a limit, and never declare success
without evidence.** The gate turns "I copied the files" into "the service
answered", and the attempt limit turns "something is wrong" into a failure the
pipeline can act on within a known time (here at most `MAX` requests and
`MAX - 1` pauses).

Three details carry the weight. A health probe should be fast, so every request
has its own timeout (`--max-time`). It should speak in exit codes, which is what
`curl -f` is for: without it a 503 page is a "successful" download. And the wait
sits *between* attempts, not after the last, so the worst case is not padded.

Retry loops like this one are everywhere: waiting for a database, for DNS to
settle, for a Kubernetes rollout. Production versions add increasing delays
(backoff) and some randomness so a hundred clients do not retry in lockstep.
The structure is the same as yours.

The test stub also shows a professional habit: sleeping is replaced by a logged
no-op, so a test can prove the script waited twice without waiting.

Going further: the gate produces a verdict, but a failing verdict leaves a bad
release live. The next level reacts to a failed gate by restoring the previous
release.

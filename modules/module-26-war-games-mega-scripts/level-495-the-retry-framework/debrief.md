# Debrief: The Retry Framework

Retries are how software copes with a world that fails transiently, and the three strategies are three opinions about how that world behaves. Fixed assumes the next try is as likely to work as the last. Linear and exponential assume that the longer the trouble lasts, the longer it will probably last, so they spend less effort the longer it goes on. Exponential back-off is how Ethernet, TCP and every cloud SDK behave, for the same reason you used here: it protects a recovering service from the very clients who are waiting for it.

Two principles beyond the formula. **Bound everything**: the number of attempts, each wait, and the total time. An unbounded retry loop is an outage waiting for a trigger. **Retry only what can change**: a missing command or a permission error will fail identically forever; a timeout or a refused connection might not. Looking at the exit status turns "retry everything" into "retry the transient".

The wrapper's discipline about *keeping the command's behaviour*: output passes through unchanged, its own messages go to stderr, and it exits with the command's status. That makes it composable in pipelines and scripts: anything you can run, you can run with retries.

There is also a lesson in the arithmetic. Doubling in a loop with an early exit avoids integer overflow that a bare shift would invite; whenever a number can grow without bound, clamp it as you go.

Going further: your tools now log, trace, retry and break circuits on their own. To see all of it at once you need telemetry in one place: metrics, logs and spans, in the observability kit, next.

# Debrief: The Circuit Breaker

A circuit breaker turns a slow, repeating failure into a fast, single one. The pattern is older than software: a fuse that melts so the house does not. In distributed systems it also gives the failing service room to recover, because a flood of retries is often what keeps it down.

The mental model is a state machine whose transitions are triggered by results and by time. The half-open state is the clever one: instead of guessing when the dependency is healthy, you test it with exactly one call. If your process dies during that probe, the file still says half-open and the next run simply probes again.

Persisting the state raised a problem you do not have in memory: crashes in the middle of a write. Writing to a temporary file and renaming is the standard answer, because rename is atomic on the same filesystem. You will see the same trick in package managers, editors and databases.

Notice also what the breaker refused to do: it never swallowed the command's exit status, never mixed its messages into the command's output, and treated an unreadable state file as an error instead of silently starting fresh.

Going further: a breaker gates calls; a feature flag gates behaviour. The next mission turns features on and off from configuration, for a percentage of users.

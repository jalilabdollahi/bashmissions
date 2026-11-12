# Debrief: The Rate Limiter

You implemented the algorithm behind most API gateways and `tc`-style traffic shapers. The mental model: a bucket that leaks in tokens at a steady rate and spends them on demand. It enforces two limits with two numbers: the capacity bounds the burst, the refill pace bounds the average.

The most important lesson is hidden in integer arithmetic. When you cannot use fractions, you must decide where the remainder lives. Here it lives in the gap between `last` and "now", which is why `last` moves by whole refill periods. The same trick appears in cron-style schedulers, in retry back-off timers and in billing meters. The full-bucket exception is a classic edge case: idle systems must not accumulate credit.

Passing the clock in as data is the second lesson. Rate limiting is notoriously hard to test with real sleeps; with a replayable timeline you could check every boundary in milliseconds, and in production the same script can re-run yesterday's access log to answer "who would we have throttled?".

Real rate limiters keep state in shared memory or Redis and must lock it. You met that problem in the previous mission: two limiters writing the same state file need the directory lock.

Going further: when a dependency is failing, limiting is not enough. You also need to stop calling it entirely. That is the circuit breaker, next.

# Debrief: The Event Bus

You built the core of every messaging system from a folder: an append-only log, a cursor per consumer, and a dispatcher. The mental model transfers directly to Kafka topics and consumer offsets, to database replication, to `journalctl --cursor`, and to the "last processed ID" column in countless cron jobs. Whenever you have to answer "has this consumer seen that event yet?", a cursor is the answer.

Reliability came from three small rules. **Move the cursor after the work succeeds**, so a crash means a repeat, never a loss (that is *at-least-once* delivery, and it is why handlers should be safe to run twice). **Never let one failing consumer block another**, and never let a failing message overtake its predecessor. **Give up eventually**: after enough failures the message is parked in a dead-letter folder, where a human can look at it, instead of blocking the line forever.

The `noclobber` trick is a lock-free way to claim a name: create-if-absent is atomic in the filesystem, the same property the directory lock exploited in the first mission of this module.

Security matters too. The dispatcher executes whatever a subscriber registered, so subscriptions must be restricted to a plain command name. Data (topics, messages) and code (handlers) have to stay separate.

Going further: delivery that fails once may succeed a moment later. How long should you wait between tries? Fixed, linear or exponential: the retry framework, next.

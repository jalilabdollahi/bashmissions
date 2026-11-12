# Debrief: Top Talkers

The mental model: **aggregate, then rank, then present, as three separate
steps.** Aggregation (awk arrays) turns many events into one row per entity.
Ranking (`sort`) needs nothing but those rows. Presentation (numbering, limit,
wording) is last. Each step has one job and a plain-text interface, so you can
test the pipeline by running its first stage alone and looking at the output.

Two sorting details are worth remembering. `-n` compares numbers; without it
`9` sorts after `10`. `-r` reverses, and it can be set per key (`-k3,3nr`).
And a ranking with ties is only well-defined if you say how ties break: here by
client name. Without it, the list changes between runs and between machines,
and "who was second?" depends on luck. Deterministic output is a feature when
a report is compared from week to week.

Note the difference between requests and bytes: the busiest client by count is
often not the heaviest by volume. Which one you rank by is a question about
the business, and the script just makes either easy.

On large logs the memory use is one entry per distinct client, not per line.
That is still too much for billions of unique addresses, but fine for any
customer-sized log.

Going further: so far every line is treated the same regardless of when it
happened. The next level selects a time window, using the fact that ISO
timestamps sort correctly as plain text.

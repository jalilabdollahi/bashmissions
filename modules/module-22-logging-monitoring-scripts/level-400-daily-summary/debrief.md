# Debrief: Daily Summary

This last level of the module is a small *pipeline of ideas*: select, aggregate,
rank, present. It is how nearly every report is made, from a shell script to a
data warehouse.

**Select.** The filter `$1 == day` throws away yesterday's tail and malformed
lines before they can distort a count. Deciding what counts is the first step of
any report, and the objective's rules ("lines of that day, well-formed") are
exactly such decisions.

**Aggregate.** awk holds state while it reads: `level[$3]++` is a histogram
in one line, and comparing each time with the current minimum and maximum finds
extremes without sorting. Doing it in one pass keeps the cost proportional to
the size of the logs, however many files there are. Zero-padded
times and ISO dates compare correctly as text, which is the payoff for the
timestamp discipline of level one.

**Rank.** `sort -k2,2nr -k1,1 | head -n 3` is the idiom for "top N, ties
alphabetical". Sorting by two keys gives a stable, reproducible report, which
matters when two people compare yesterday's email.

**Present.** Separating data (a tagged stream) from layout (the echo
lines) means you can change either without touching the other.

You now have a toolbox for on-call work: timestamps, levels, rotation, parsing
system tools, freshness, rates, metrics, restarts, alerts, audit trails and
summaries. Module 23 uses the same habits to build and ship software.

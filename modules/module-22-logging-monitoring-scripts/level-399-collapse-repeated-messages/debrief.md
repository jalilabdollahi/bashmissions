# Debrief: Collapse Repeated Messages

Logs are only useful if people read them, and nobody reads eleven thousand
copies of one sentence. Folding repeats keeps the first occurrence as evidence
and replaces the flood with a count, so the rare line that explains the problem
stays visible. Syslog daemons and journald do exactly this.

The programming idea is **run-length processing with deferred output**: you can
only say "that was the end of the run" when the next item arrives, so output is
delayed by one step and a counter stands in for the skipped lines. Whenever a
loop must decide *after* seeing the next element, there are two places where
the pending state must be written out: when the thing changes, and when the
input ends. Forgetting the second one silently drops the last group; test the
case where the file ends in a repeat.

Two choices of detail are worth noting. First, the comparison key is the
message *without* the timestamp; otherwise nothing ever repeats. Choosing what
counts as "the same" is half of any deduplication job. Second, only
*adjacent* repeats are folded. Merging across gaps would hide the pattern
"fails, recovers, fails again", which is exactly what an engineer needs to see.

Putting the output code in a small function (`flush`) means it exists once and is
called twice, a habit that prevents the two copies drifting apart.

Going further: the last level of this module applies the opposite idea: not
folding a log, but summarising a whole day of it.

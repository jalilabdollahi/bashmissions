# Debrief: Append Entries

## What you learned

`>` says "make the file look like this"; `>>` says "add this to what is
there". Anything that records history (logs, audit trails, journals) must
append. The timestamp turns a list of events into a timeline.

## Under the hood

`>>` opens the file in append mode: the kernel moves every write to the
current end of the file, even when two processes append at once. That is why
several scripts can share one log without overwriting each other (their
lines may interleave, but none vanish). `date +FORMAT` simply asks the
system clock and formats it; the part after `+` is yours to design.

`shift` is plain bookkeeping on the argument list: `$2` becomes `$1`, `$#`
drops by one, and `"$@"` now means "everything after the old first
argument".

## In real work

A timestamp layout of year-month-day-hour sorts correctly even as plain
text, so `sort` and `grep` over such logs just work. Many teams keep a
tiny `log_event` helper exactly like this one in all their scripts.

## Going further

You have written to files in three ways now: create, protect, append. Next
we read in the other direction: loading a whole file into a variable.

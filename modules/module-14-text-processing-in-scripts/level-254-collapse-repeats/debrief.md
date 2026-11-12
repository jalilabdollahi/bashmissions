# Debrief: Collapse Repeats

`uniq` is smaller than its reputation. It does not find duplicates in a file;
it removes duplicates that are next to each other. The reason is design: by
looking at only one previous line it needs almost no memory, so it can
process a stream of any length, live, as it arrives.

That gives you two distinct jobs for the same tool. On time-ordered data
(heartbeats, state changes, a log in order) plain `uniq` is a "tell me when
it changes" filter. On unordered data you put `sort` in front so equal lines
become neighbours, and then `uniq` gives you the distinct values. The
difference is not the tool but whether the order is something you want to keep.

Under the hood, "same" means byte-for-byte identical, so a line with a trailing
space is different from one without. Cleaning up whitespace first is a typical
step before `uniq`.

Going further: when equal lines are grouped, you can also ask how many there
were in each group. That is `uniq -c`, which turns a log into a frequency table
in the next level.

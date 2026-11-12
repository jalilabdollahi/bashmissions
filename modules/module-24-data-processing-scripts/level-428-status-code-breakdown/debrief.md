# Debrief: Status Code Breakdown

The mental model: **group by a derived key.** In the earlier group-by the key
was a column; here it is a function of a column. That small step is the heart of
most real reporting: status to class, timestamp to hour, size in bytes to size
band, path to its first directory. Compute the bucket name, then count under
it. Everything else is the same.

The second idea is separating *what exists* from *what the report promises*.
`for (k in count)` describes what happened; a fixed list describes what the
reader expects. A dashboard that sometimes has a `5xx` row and sometimes does
not is hard to read and impossible to compare day to day. A zero is
information ("no server errors today"), and the missing line is not.

Notice also the `other` bucket. Real data always contains something you did not
plan for, and a report whose parts do not add up to the total makes people stop
trusting it. Counting the unclassifiable explicitly keeps the arithmetic
honest and makes the damage visible.

The percentages need a guard because empty input is normal (a quiet host, a
rotated log) and division by zero stops awk dead.

Going further: classes tell you how the traffic went. The next level asks who
generated it, and ranks clients by how busy they were.

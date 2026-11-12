# Debrief: awk Group By

"Group by" is one of the most common questions about data: per customer, per
host, per day, per status code. SQL has `GROUP BY`; awk has associative arrays,
which are the same idea. An array maps a string key to a value, creates
entries on demand, and starts them at zero, so `total[$2] += $3` is a complete
group-by in one line.

Two things to remember. First, the keys are always strings: `a[1]` and `a["1"]`
are the same element, and there are no real multi-dimensional arrays. Second,
`for (k in a)` returns the keys in an unspecified order. It is not insertion
order and not sorted, and it differs between implementations. That is why the
usual finishing move is to pipe the result into `sort`. Letting each tool do
the one thing it is good at is the Unix way again: awk groups, sort orders.

Under the hood an awk array is a hash table, so each line costs about the same no
matter how many groups there are. A million-line log with ten thousand
customers is a one-pass job that uses only memory for the keys.

Going further: the other half of awk's power for files is editing lines in
place. The next levels switch to `sed` and the line-oriented edits it was
built for.

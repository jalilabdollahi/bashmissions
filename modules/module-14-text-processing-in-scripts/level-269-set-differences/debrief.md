# Debrief: Set Differences

Many operational questions are set questions: which servers are in the
inventory but not in monitoring, which users exist on one host and not the
other, which files were added since yesterday. `comm` answers them. Give it
two sorted lists and it classifies every line as left-only, right-only or both,
and the numbered flags select what to show: `-12` is the intersection, `-23`
the left difference, `-13` the right one.

Like `join`, `comm` is fast and frugal because it relies on sorted input. It
reads one line from each file at a time, comparing and advancing the smaller,
which is the merge step of a merge sort. The price is the same warning as before:
feed it unsorted data and it will not fail loudly, it will just be wrong. The
sort must also match the locale `comm` uses, so scripts set `LC_ALL=C`
at the top.

Notice, too, how small the final script is: two lines, each a pipeline of two
general tools. None of them knows about customers. This is how Unix scripts
stay short.

Going further: the data we have printed so far was never meant to be pretty.
Next you format output into aligned columns, ready for a human to read.

# Debrief: Head and Tail Windows

Many questions about a file are positional: "show me the beginning", "what are
the last few lines", "give me the middle". `head` and `tail` answer them
without loading the file into an editor or a variable. `head` can stop reading
as soon as it has enough lines, so on a huge file it finishes instantly;
`tail -n 5` on a big log seeks near the end instead of reading from the top.

The plus form is the part to remember: `tail -n 5` means "the last five lines",
but `tail -n +5` means "from line five onward". Same flag, different meaning,
which makes `tail -n +2` the classic way to skip a header line. Combined with
`head` it gives you a window, and the window logic is the same in every language
that slices a list: keep up to the end, then drop up to the start.

Under the hood this is the stream idea again: `head` writes lines and exits,
`tail` reads lines and decides what to forward. Neither needs to know what a
log line looks like.

Going further: head and tail pick lines by position. Soon you will pick them by
content, first with `awk` and then with `sed` ranges that start and end at
patterns instead of numbers.

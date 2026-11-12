# Debrief: Frequency Table

`sort | uniq -c | sort -rn` is probably the most reused pipeline in operations.
Whatever the question is (top clients, most common error, busiest hour), the
shape is the same: extract one value per line, group, count, rank. Four tools,
each unaware of the others, combine into something none of them could do alone.
This is the Unix filter philosophy in action: small programs that read lines
and write lines, joined by pipes.

Notice why the first `sort` is there. `uniq` has no memory of earlier lines; it
only compares neighbours. Sorting turns "the same value somewhere in the file"
into "the same value in a block", which is the only thing `uniq` understands.

The padded count from `uniq -c` is a reminder that tools differ. macOS right-
aligns in a narrower column than GNU does, so a script that compares the raw
output breaks when it moves. Stripping the padding, or reformatting with awk,
makes the output portable.

Going further: when the data is not one column but several, you will want a
tool that handles fields itself. The next levels turn to `tr` for characters and
then to `awk` for fields.

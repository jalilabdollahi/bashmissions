# Debrief: Comparing Numbers

Bash has no number type. Everything is text, and the operator decides how the
text is read. `==` reads both sides as strings; `-lt`, `-ge` and friends read
them as integers. Choosing the wrong family is the single most common
conditional bug: `[[ 9 > 70 ]]` is true, because 9 sorts after 7 as a string.

## Under the hood

The numeric operators convert both sides to integers and compare them. If a side
is not a number, Bash complains ("integer expression expected" or a syntax error
inside `[[ ]]`), which is better than silently giving a wrong answer. These
operators are whole numbers only; Bash cannot compare 3.5 with 3.7 by itself.

Bands that overlap are best written as a ladder ordered from the strictest
condition to the loosest. Each rung can then assume that the earlier ones were
false, which keeps the tests short.

## Where it shows up

Disk and memory thresholds, retry counters, HTTP status ranges, "how many
approvals do we have?", port numbers, and every monitoring script ever written.

## Going further

`[[ $used -ge 90 ]]` is readable but a bit clumsy. Bash has a second syntax,
double parentheses, that lets you write the comparison like school maths. That
is the next level.

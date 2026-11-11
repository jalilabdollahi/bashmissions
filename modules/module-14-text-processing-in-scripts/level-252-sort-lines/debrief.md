# Debrief: Sort Lines

`sort` is the first of the classic filters: a program that reads lines from
standard input, does one thing, and writes lines to standard output. You will
soon stack several of them with pipes, and each one can stay tiny because the
others cover what it does not.

The default ordering is the part that surprises people. `sort` has no idea that
`10` is a number; it compares characters from the left, so `10` lands before
`2` and `Z` lands before `a`. That is also why the locale matters. In a UTF-8
locale many systems fold case and ignore punctuation, so the same file sorts
differently on a laptop and on a server. Scripts that need a stable order set
`LC_ALL=C`, exactly as this game does for you.

Under the hood `sort` is an efficient merge sort that spills to temporary files
when the input is bigger than memory. That is why `sort` happily handles a log
with ten million lines when a bash loop would give up.

Going further: real data has columns. The next level sorts by one field and by
numeric value, which fixes the rack 10 problem properly.

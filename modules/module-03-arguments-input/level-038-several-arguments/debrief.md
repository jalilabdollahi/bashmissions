# Debrief: Several Arguments

Positional parameters are simply the command line cut into words and numbered
from one. Your script is a function of those words: change a word, change the
result. The sentence you print has its own order, and that is independent of the
order the arguments arrive in, which is why naming them (`seats=$3`) pays off.

Under the hood the shell does the cutting. Spaces separate words, and quotes tell
the shell "this is one word". By the time your script starts there is no
punctuation left to reason about, only the numbered values.

In real work this is how you build small tools with a clear contract, like
`backup.sh SOURCE DEST` or `resize.sh DISK SIZE`. Remember the order is part of
the interface: the day someone swaps two arguments, the script happily runs with
the wrong data.

One more detail: `$10` is read as `$1` followed by a zero. From the tenth
argument on you must write `${10}`.

Going further: how do you know how many arguments you actually received? That is
the next level.

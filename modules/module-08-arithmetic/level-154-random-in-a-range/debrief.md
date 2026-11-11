# Debrief: Random in a Range

## What you learned

`$RANDOM` plus `%` is the standard recipe for "a random number from LOW to
HIGH": `low + RANDOM % (high - low + 1)`. And seeding with `RANDOM=n`
turns chaos into something you can replay and test.

## Under the hood

Each read of `$RANDOM` gives a pseudo-random integer between 0 and 32767,
which is 15 bits. Assigning to the variable resets the generator, and after
that the same sequence follows, which is why the tests of this level can only
check range, line count and repeatability, not particular numbers.

Two limits matter. First, with only 32768 possible values, a range that does
not divide 32768 evenly is slightly biased towards its lower values (for a
range of 1000, the first 768 values appear about 3% more often). This is fine for
jitter and a pub raffle, and not fine for secrets. Second, `RANDOM` is not
cryptographically secure. For tokens and passwords read from `/dev/urandom`
instead. If your range is bigger than 32768, combine two draws or use another
source.

The exact sequence for a given seed can also differ between Bash versions,
so never write a test that depends on specific numbers.

## In real work

Backup and cron jitter, random sampling of lines, picking a server for a
canary test, shuffling a retry delay.

## Going further

You can now generate numbers. Next, a number-crunching job on data you are given:
one pass over a list to get its total, smallest and largest values.

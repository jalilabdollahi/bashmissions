# Debrief: Log Line Parser

This level is the module in one script. Anchors and classes define the *shape* of
a valid line; quantifiers and alternation absorb the variations (padded days,
`password|publickey`); groups pull out the *fields*; and an optional group lets two
formats share one pattern. Everything that does not fit is silently ignored,
because a log always contains lines you did not plan for.

The professional habit is to treat a regex as a **parser with a contract**. The
pattern says exactly what a good line looks like, and the rest of the script can
trust `BASH_REMATCH` without re-checking. Garbage lines are rejected at the door, as
in the test with the trailing `extra` and the empty username.

Notice also the split of labour. The regex handles text; Bash handles *meaning*.
Counting per address, remembering the last user, and deciding that a login is
suspicious only if it came *after* three failures are things regexes cannot do. The
associative array is the memory, and the order of the `if` branches inside the loop
is the timeline.

A caution on optional groups: they keep their number even when absent. If you
find yourself guessing indexes, run `declare -p BASH_REMATCH` on a sample line.
It prints the whole array and ends most debugging sessions at once.

Where to go from here: you now have the full set of tools for text. Next up are
files, where the same care about edge cases (spaces, missing files, odd names)
protects you from deleting the wrong thing.

# Debrief: Reject Empty Input

Level 50 asked "is it the right shape?". This one asks the cheapest and most
valuable question of all: "is there anything there?". Empty values are the most
common bad input in shell scripts, from a blank Enter to an unset variable
expanding to nothing in front of `rm -rf "$dir/"`.

`-z` (zero length) and `-n` (non-zero length) are the two test operators for it.
They work on any string, not just input.

The `read ... || true` idiom shows a general principle of `set -e` scripts: a
command that may legitimately fail needs an explicit plan. `||` provides the
plan, and the plan here is "carry on, and check the result yourself". The
variable initialised beforehand makes that check reliable.

There is also a lesson about equivalence: two different situations (empty line,
no line) can lead to the same internal state (empty variable). Collapsing them
keeps the rest of the script simple.

Going further: next you combine arguments and stdin so that one script serves
both a human at the keyboard and a pipeline.

# Debrief: Fix the Off-by-One

The off-by-one is the most common bug in programming, and it comes from the
gap between *counting* and *indexing*. Counting starts at 1 ("three backups"),
array indexes start at 0 ("elements 0, 1, 2"). A loop with `i < n` runs for
indexes 0 to n-1, which is n iterations. Write `i <= n` and you get n+1. Neither
operator is "wrong"; the bug is picking the one that does not match the
question you asked.

The method matters more than this particular bug. A reliable debugging routine:

1. **Reproduce** with the smallest input that shows the problem.
2. **Observe** instead of reading: `bash -x`, a debug print, or `declare -p` on
   the array. The trace shows what the script *did*, which is often not what you
   believe it did.
3. **Predict** by hand for a tiny case, and compare. The first place where
   the machine and your paper disagree is the bug.
4. **Change one thing**, then run the same reproduction again.
5. **Test the edges**: zero, one, exactly the limit, empty input, because that
   is where off-by-ones hide. Here KEEP=0 was the case that crashed under
   `set -u`.

Notice how the earlier tools in this module pay off: the trace and its line
numbers locate the iteration; assertions or a harness turn the reproduction into
a test you can rerun after every edit.

Going further: sometimes the bug is not in one loop but somewhere in a long
sequence of steps. The last level shows how to find a failing step without
trying them all.

# Debrief: Validate a Date

A date has three layers of correctness: how it **looks**, whether its parts are
**in range**, and whether the **combination** exists. Each layer needs a different
tool. The regex answers the first, comparisons answer the second, and a little
calendar knowledge answers the third. Trying to push all three into one regex
produces something nobody can maintain, and it still cannot know about leap years.

The structure of the script is worth copying: a chain of early exits. Each
check either rejects the line with a *specific* message and `continue`s, or lets
it through to the next, stricter check. Specific messages are the difference
between a validator people trust and one they work around: "bad day" tells Gus
which cell to fix.

The leap-year rule is a good example of why you write the rule exactly as the
domain states it, instead of guessing: every fourth year, except centuries, except
every fourth century. Test the boundary years (1900, 2000, 2100) to be sure.

And once more: leading zeros. `08` and `09` look innocent, but in arithmetic they
are octal digits that do not exist. Whenever digits come from text, `10#` is
your friend.

Going further: all of these regexes lived in single quotes inside a variable.
There is a reason, and it has a name, and it is the next level.

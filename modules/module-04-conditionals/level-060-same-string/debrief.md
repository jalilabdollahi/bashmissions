# Debrief: Same String?

`==` inside `[[ ]]` asks one question: are these two strings identical? There is
no "roughly equal", no ignoring case, and no trimming of spaces. That strictness
is exactly what an audit needs.

## Under the hood

`[[ ]]` is part of the Bash language itself, not an external program, so it
parses its contents specially. Variables on the left are not split into words,
which is why `[[ $running == ... ]]` survives a value like `blue green`. The
right-hand side is the surprise: it is a pattern, so `*`, `?` and `[abc]` act as
wildcards. Quoting it turns the pattern off. Next to the old `[ ]` syntax this
is a feature, but you have to know about it. Level 72 uses the wildcard
behaviour on purpose.

## Where it shows up

Checking that a config value is what you expect, that a deployed version matches
the release sheet, that a hostname is the one a script was written for. Any time
someone says "make sure it is exactly X", this is the test.

## Going further

Equality is half of the story. Often the useful question is the opposite: is it
*not* the thing it should be? That is the next level, and it makes a great guard
at the top of a risky script.

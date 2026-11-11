# Debrief: Negated Classes

Greedy repetition is the source of more regex bugs than anything else. `.*` takes
as much as it can, so between two delimiters it overshoots whenever the delimiter
appears again later. Other regex dialects give you a lazy `.*?`. POSIX ERE
does not, and shell regexes, `grep -E` and `sed -E` are POSIX. The replacement is
better than the original idea anyway.

**Describe the content, not the stopping point.** Text between quotes is "any
characters except a quote", written `[^"]*`. A negated class has a built-in
boundary: it can never cross the delimiter you excluded, so the match ends exactly
where the delimiter begins. The same trick works for everything with delimiters:

- `\[([^]]*)\]` text in square brackets,
- `\(([^)]*)\)` text in parentheses,
- `([^,]*),` one CSV field (not a quoted one),
- `://([^/]*)/` the host of a URL.

Two small points. `*` accepts zero characters, so an empty `msg=""` yields an
empty capture and still counts as a message. Use `+` instead if "at least one" is
the rule. And putting the regex in a single-quoted variable makes a pattern full
of double quotes painless, which is the practical value of the habit from level
225.

Going further: the last level combines everything in this module into one parser
that turns a messy log line into a decision.

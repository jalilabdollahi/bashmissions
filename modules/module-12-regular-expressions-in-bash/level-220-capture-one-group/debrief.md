# Debrief: Capture One Group

Matching tells you *whether*; capturing tells you *what*. Parentheses do two jobs
in a regex: they group (as you saw with `(a|b)`), and they **remember**. Every
successful `=~` stores what each group matched in the array `BASH_REMATCH`.
Element 0 is the whole match, and elements 1, 2, 3... are the groups counted by
their opening parenthesis.

The art of a good capture is the shape of the group. You do not describe *the
username*, you describe *what a username is made of*: characters that are not a
space. `[^ ]+` is the everyday workhorse for "a word" because it stops exactly at
the delimiter that follows. The text around the group is what gives the match its
meaning, so keep it: "for " before and " from " after make sure you capture the
right word and skip lines that merely contain a similar one.

Remember where the array comes from. It is rewritten by every `=~` and only
trustworthy after a match succeeded, which is why the read sits inside the `if`.
A script that prints `${BASH_REMATCH[1]}` unconditionally will print stale data
for lines that did not match.

In real work this is how you turn raw log lines into data: usernames, IPs,
request paths. It is the first half of every log report.

Going further: one group gives one value. Next you will pull out several pieces
from the same line with a single match.

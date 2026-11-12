# Debrief: Find the Failing Step

Bisecting is debugging by elimination. You do not need to understand the whole
system; you only need a test that answers "is the problem in this part?" and a
way to shrink the part. Each test halves the suspects, so a thousand candidates
take ten tests.

Two conditions make it work. The test must be *monotonic*: once the culprit is
included the result stays "fail" however much more you add (here: the first K
steps contain the broken one or they do not). And the interval must keep an
invariant, a sentence that stays true after every move: "the first failing step
is somewhere in lo..hi". The two assignments in the loop exist to keep that
sentence true. `hi=mid` and `lo=mid+1` are not arbitrary: mid may be the culprit
itself, so a failing result keeps it, while a passing result proves mid is
innocent and can be thrown away. Getting these wrong gives either an endless loop
or an off-by-one, the bug from the previous level.

The same idea is built into `git bisect`, which finds the commit that broke a
test by repeatedly checking out the middle of the history. It works on configs
("which of these forty settings breaks it?"), on input files ("which line of this
CSV crashes the importer?") and on deploy plans like this one.

Notice that shell lets you treat any command as a question: `if cmd; then` turns
its status into yes or no, and you decide what its output is worth.

Going further: that closes the module. You can now make a script show its work
(traces, prefixes, files), explain its own failures (line numbers, stacks, traps),
rehearse (dry run), check itself (assertions, harness) and narrow down a bug
by method. The next module is about processes and signals.

# Debrief: Audit Wrapper

An audit wrapper is the last of the wrappers, and the one that makes the
others trustworthy. Every ingredient has come up before in this module:
forward `"$@"` exactly, capture the status with `|| rc=$?`, return it
unchanged, do the extra work in between. The extra work here is a single line
appended to a file.

## What makes a log useful

- **Faithful**: `%q` records the words as the shell saw them, so `a;b` and `a b`
  cannot be confused. A log that is ambiguous is worse than none.
- **Complete**: failures and "command not found" are logged like successes. The
  interesting entries are the ones that went wrong.
- **Append-only**: `>>` never rewrites history. Real audit logs also live
  where the audited user cannot edit them.
- **Quiet when idle**: nothing is created if nothing ran.

## Under the hood

`printf -v name '%q ' "$@"` loops its format over every argument, giving
one escaped word per argument with a trailing space, which `${name% }`
removes. `read -ra` fills an array by splitting on `IFS` only, with no globbing,
so a `*` in the input is data, not a wildcard (the test checks both what it
printed and what it logged).

One caveat: the wrapper records what it was *asked* to run. It cannot tell
you whether an inner command misbehaved; it stops at the command boundary.

## The module in one picture

You built tables of functions (dispatch, plugins, hooks, events), functions
that remember (memoize, generators, iterators), functions that make or wrap
functions (factories, decorators, builders, strategies, middleware), and
wrappers that add a behaviour to any command (retry, timing, audit). Together
they are how a Bash program stays manageable as it grows.

## Going further

The next module moves from functions to processes: running things in the
background, waiting for them, and signals.

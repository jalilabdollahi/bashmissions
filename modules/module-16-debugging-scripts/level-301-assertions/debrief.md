# Debrief: Assertions

An assertion is a claim written in code: "at this point, this is true". When the
claim holds, the script says so briefly and carries on. When it does not, the
script says exactly what it expected and what it found, then fails. That moves
debugging from a hunt ("why is the output wrong?") to a pointer ("this value was
8081, not 8080").

Three design choices make `assert_eq` useful. The failure message contains
*both* values, so you rarely need to rerun with extra prints. The failure goes
to stderr and sets a non-zero status, so other scripts, `set -e` and CI can react
to it. And the comparison is literal: the quotes around the right-hand side of
`[[ == ]]` prevent glob matching, which would let `a*` accept `abc` and silently
weaken your check.

Notice also what the function does not do: it does not exit. It returns a
status and leaves the decision to the caller. That is what makes it reusable:
the next level runs many assertions in a row and counts the failures instead
of dying at the first. If you called `exit 1` inside, you could never do that.

Real-world versions of this idea sit in test frameworks such as bats and in
the preamble of deployment scripts ("assert the target is staging before
continuing").

Going further: one assertion per script is a toy. A set of named test functions
and something to run them is a test harness.

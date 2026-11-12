# Debrief: Parse Test Results

The mental model: **a machine-readable format is a contract, and parsing means
honouring all of it.** `grep -c ok` fails because it ignores the structure:
`not ok` contains `ok`, comments contain `ok`, and a SKIP is neither a pass nor a
failure. Anchored patterns plus a small classification table reproduce the
contract exactly.

The plan line is the clever part of TAP. A test runner that crashes after
three of five tests prints no error that a human script could spot, yet all
three results look fine. Comparing the announced count with the real count
turns "silently incomplete" into a loud failure, which is why this level gives
it its own exit code.

Under the hood each `[[ =~ ]]` match fills `BASH_REMATCH`; group numbers follow
the opening parentheses from left to right, so an optional group such as
`(-[[:space:]]*)?` still occupies a slot even when it matched nothing.

You will meet TAP in `prove`, Bats, `node --test` and many CI plugins. JUnit XML
and JSON reports follow the same idea with different syntax.

Going further: counting tests is half of a quality gate. The next level takes
a number from a coverage report and decides whether the build may continue.

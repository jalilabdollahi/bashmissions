# Debrief: A Mini Test Harness

You have just built the core of every test framework: discover, isolate, judge,
report. The rest (colours, timing, fixtures) is decoration on top of that loop.

Discovery is possible because functions are data. Bash keeps a table of them,
and `compgen -A function` reads it. A naming convention (`test_`) turns that
table into a test suite without any registration code: write a function with
the right name, and the harness finds it.

Isolation is what makes the verdicts trustworthy. A subshell is a copy of the
running shell: the test sees all your functions and variables, but whatever it
changes (variables, the working directory, even `exit`) dies with the copy. That
is why the last test in the exercise sees `count` as 100 even though another
test set it to 0. If you ran tests in the same shell, they would leak into one
another and results would depend on order.

The verdict is just an exit status: 0 for pass, anything else for fail. That is
why an assertion helper from the last level fits in naturally: a test is a
function that ends with `assert_eq ...`. And because the harness itself exits 1
when anything failed, CI systems and `&&` chains can use it directly.

A subtle point to remember: a function called in an `if` condition runs with
`set -e` switched off, so inside a test, a failing line in the middle does not
stop the test by itself. Make tests chain their checks (`a && b`) or end with
the assertion that decides.

Going further: now that you can run checks, practise on someone else's broken
script. The last two levels give you one to fix.

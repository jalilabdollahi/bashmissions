# Walkthrough: The Test Harness Builder

## The plan
A test framework is a very small idea: run a piece of code, decide whether it "worked", and report. Bash
makes the decision easy because everything already has an exit status; what a harness adds is
*discipline*: each test runs alone, in a clean place, with helpers, and a crash in one test cannot
hide the others. The design has three layers: discovery (which functions are tests?), execution (run one,
classify the result) and reporting.

## Step by step
1. **Arguments and files.** Options, then `PATH...`; directories expand to their `*.test.sh` files in glob (name)
   order. Unreadable paths are an error before anything runs.

2. **Discovery by reading, not running.** `sed -n -E` extracts `test_name` from lines that look like
   `test_name()` or `function test_name`, in the order they appear. Reading the text means no test
   code executes during discovery. Counting names across all files lets the script say `no tests found`
   up front instead of printing an empty report.

3. **The assertion API.** Plain functions defined in the runner. A subshell inherits every function of its
   parent, so they are available to tests without exporting. `fail` writes its message to a file and exits the
   *subshell* with status 1; `skip` exits 77. Why a file? An exit status carries only a number, and the
   subshell's stdout belongs to the test (it is captured for `--verbose`).

4. **Executing one test.** In `run_test`: make a fresh directory with `mktemp -d`, then run
   `( set -e; cd ...; source file; setup; test )`. Sourcing inside the subshell means each test sees a
   pristine copy of everything the file defines, and variables or functions it sets die with the
   subshell. `trap teardown EXIT` registered after sourcing guarantees cleanup however the test ends.

5. **The errexit trap.** The natural way to write the call is `( ... ) || status=$?`. It looks right and
   silently breaks the harness: bash disables `set -e` for every command inside a construct that is
   part of an `||` or `if` condition, *including everything in the subshell*. A test would then carry on
   after its first failing command and could pass by accident. The fix is to turn errexit off around the
   subshell with `set +e`, run it as a plain command, read `$?`, and turn it back on.

6. **Outcome.** `0` is PASS, `77` is SKIP, anything else FAIL with either the test's message or
   `exited with status N`. `bash -n` runs first on each file, so a typo in one test file becomes one clear
   `ERROR` line instead of ten confusing failures.

7. **Report.** One line per test, optional `| ` prefixed output for failures, `--fail-fast` via a flag the
   loops check, a summary, and exit status 1 for any failure or file error.

## Try it by hand
```
./solution.sh --verbose tests/math.test.sh
./solution.sh --filter status tests
```

## Alternative
Sourcing every test file once and calling each function in the same shell is faster, but tests
then share variables, working directory and traps, and a failing `exit` ends the whole run. The cost
of one subshell per test is a few milliseconds and buys real isolation.

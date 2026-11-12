# Common Mistakes

- **`( ... ) || status=$?`.** Wrong: errexit is ignored inside the subshell, so a test keeps running after `false` and may "pass". Right: `set +e; ( set -e; ... ); status=$?; set -e`.
- **Sourcing the test file in the runner's shell.** Wrong: a test's variables, `cd` and traps leak into the next test, and a stray `exit` ends the whole run. Right: source inside the per-test subshell.
- **Discovering tests with `declare -F`.** Wrong: it lists functions alphabetically and only after running the file's top-level code. Right: read the text with `sed -n -E` and keep file order.
- **Teardown only on success.** Wrong: calling `teardown` after the test line, skipped by the first failure. Right: `trap teardown EXIT` inside the subshell.
- **Sharing one working directory.** Wrong: a file left by test A makes test B pass or fail depending on order. Right: a fresh `mktemp -d` per test.
- **Assuming a message from an exit status.** Wrong: using `exit 1` for everything and printing "failed". Right: write the reason to a file, and keep a special status (77) for skips.

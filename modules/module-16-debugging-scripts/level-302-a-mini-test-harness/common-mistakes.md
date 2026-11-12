# Common Mistakes

- **Piping into the loop.** Wrong: `compgen -A function test_ | while read ...; do passed=...; done` runs the loop in a subshell and the totals print as 0. Right: `done < <(compgen ...)`.
- **`((passed++))` under `set -e`.** The expression's value is the old 0, so the status is 1 and the harness dies after its first success. Right: `passed=$(( passed + 1 ))`.
- **Running tests in the current shell.** Wrong: `if "$name"; then` means a test that calls `exit 5` ends the harness and one that sets a variable changes the next test's world. Right: `if ( "$name" ); then`.
- **Letting test output through.** Without `> /dev/null 2>&1`, a noisy test prints into the report and breaks the expected format.
- **Forgetting `sort`.** The listing order is not guaranteed to be alphabetical, so reports differ from run to run. Sort the names.

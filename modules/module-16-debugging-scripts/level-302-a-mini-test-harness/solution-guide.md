# Walkthrough: A Mini Test Harness

## The plan
A harness is a loop with three responsibilities: discover tests, isolate them,
and report. Bash gives us each piece: `compgen` for discovery, subshells for
isolation, exit statuses for verdicts.

## Step by step
1. Load the file so its functions exist in this shell:

   ```bash
   source "$1"
   ```

2. List the test names. `compgen -A function test_` prints every function
   name that begins with `test_` (helpers like `price` are skipped). Pipe it
   through `sort` for a stable order and read it line by line:

   ```bash
   while IFS= read -r name; do
     ...
   done < <(compgen -A function test_ | sort)
   ```

   The `< <(...)` form keeps the loop in the current shell, so the counters
   survive after `done`. A plain pipe would run the loop in a subshell and
   throw the counts away.

3. Run each test isolated and silent:

   ```bash
   if ( "$name" ) > /dev/null 2>&1; then
   ```

   The parentheses start a child shell. `test_quits` calling `exit 5` ends only
   the child, and `test_changes_state` changes only the child's copy of
   `count`. The `if` turns the status into a yes/no answer, so a failing test
   does not trigger `set -e`.

4. Count with `passed=$(( passed + 1 ))`. The tempting `((passed++))` returns
   status 1 when `passed` is 0, and `set -e` would kill the harness on the very
   first pass.

5. Print the totals and make the last command `(( failed == 0 ))`: its status
   is 0 for "no failures" and 1 otherwise, which becomes the script's status.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
passed=0
failed=0
source "$1"
while IFS= read -r name; do
  if ( "$name" ) > /dev/null 2>&1; then
    echo "PASS $name"
    passed=$(( passed + 1 ))
  else
    echo "FAIL $name"
    failed=$(( failed + 1 ))
  fi
done < <(compgen -A function test_ | sort)
echo "$passed passed, $failed failed"
(( failed == 0 ))
```

## Try it by hand
```bash
printf 'test_ok() { true; }\ntest_bad() { false; }\n' > suite.sh
./solution.sh suite.sh; echo "status=$?"
```

## Alternative
`declare -F | awk ...` lists functions too, but `compgen -A function PREFIX`
does the filtering for you and has a stable, simple output format.

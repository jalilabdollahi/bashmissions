# Walkthrough: until It Is Ready

## The plan
Ask the probe. If it says "not ready", say so and ask again. Stop at the first "ready". The number of questions asked is what the final line reports.

## Step by step
1. Start a counter that names the check currently being made: `check=1`.
2. Write the loop: `until replica-status; do`. The condition is the command itself. Bash runs it, looks at its exit status, and treats non-zero as "keep going". Exit 0 ends the loop.
3. The body runs only after a failure, so it prints `check $check: not ready` and then bumps the counter.
4. When the probe finally succeeds, the loop ends with `check` already holding the number of the successful check, because you only increment after failures.
5. Print the final line after `done`.

## Complete solution

```bash
#!/usr/bin/env bash
check=1
until replica-status; do
  echo "check $check: not ready"
  check=$(( check + 1 ))
done
echo "replica ready after $check check(s)"
```

## Trying it by hand
The test environment puts a fake `replica-status` on your PATH. In the workspace try `FAKE_READY_AFTER=4 bash solution.sh` and watch it count. In real life you would add `sleep 2` to the body so you do not hammer the replica.

## An alternative
`while ! replica-status; do ... done` behaves identically. The exclamation mark negates the status. It works, but `until` says what you mean: wait until the thing is ready. Pick whichever reads more naturally.

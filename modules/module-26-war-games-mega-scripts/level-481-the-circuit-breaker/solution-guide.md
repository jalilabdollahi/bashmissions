# Walkthrough: The Circuit Breaker

## The plan
A circuit breaker protects a failing dependency from the people calling it, and the callers from waiting on it. It is a three-state machine:

- **closed**: normal. Calls go through; consecutive failures are counted.
- **open**: too many failures. Calls are refused instantly for a cooldown period.
- **half-open**: the cooldown is over. One probe call is allowed; its result decides whether to close or reopen.

In a long-running server the state lives in memory. A shell script is a new process every time, so the state goes in a three-line file: `state`, `failures`, `opened_at`. The clock, as in the previous missions, is an argument.

## Step by step

1. **Settings.** `THRESHOLD` and `COOLDOWN` come from the environment with defaults (`${THRESHOLD:-3}`) and are validated before anything else, because a bad number would later blow up inside `(( ))`.

2. **Load.** A missing file is the healthy default. Otherwise read the three keys with `IFS='=' read -r key val`, validate each, and count how many valid keys were seen: fewer than three, or any unknown key, is corruption and exit 2. Refusing to guess is the right behaviour for a safety device.

3. **Run the guarded command.** `"$@"` after `shift` is the command with its arguments intact. Under `set -e` a failing command would end the script, and you must still update the state, so write `"$@" || status=$?`. The command's stdout and stderr are not touched; the breaker speaks on stderr with a prefix so the two streams stay separable.

4. **Decide.** For `open`, compare `now - opened_at` with the cooldown. Still cooling: skip the call and exit 75 (`EX_TEMPFAIL`, a status that is unlikely to collide with a real command's). Elapsed: set `state=half-open` and continue into the common code. After the call, a half-open breaker closes on success or reopens with a fresh `opened_at` on failure; a closed one resets or increments its counter and opens at the threshold.

5. **Save atomically.** `mktemp` in the same directory, `printf` the three lines, `mv -f` over the real file. `mv` within one filesystem is a rename, which readers see as old-or-new, never half. A `trap ... EXIT` removes the temp file if anything fails earlier.

6. **status / reset** are small: status reuses the same arithmetic without running anything.

## Complete solution
```bash
"$@" || status=$?
if [[ $state == half-open ]]; then
  (( status == 0 )) && { state=closed; failures=0; opened_at=0; } \
                    || { state=open; opened_at=$now; }
fi
```
That fragment is the heart; `answer.sh` shows it in context once you pass.

## Try it by hand
```bash
FAKE_PAY=fail ./solution.sh bk.state run 1000 payments-api charge X1
FAKE_PAY=fail ./solution.sh bk.state run 1001 payments-api charge X2
FAKE_PAY=fail ./solution.sh bk.state run 1002 payments-api charge X3   # OPEN
./solution.sh bk.state run 1010 payments-api charge X4                 # skipped
cat bk.state
```

## Alternative
Keep a failure count per time window instead of consecutive failures, or require several probe successes before closing. The consecutive-count version is easier to reason about and is how many libraries start.

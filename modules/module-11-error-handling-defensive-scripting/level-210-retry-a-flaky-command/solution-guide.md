# Walkthrough: Retry a Flaky Command

## The plan
An attempt counter, a limit, and `lanternpush` as the condition of an `if`. The
loop leaves early on the first success; if it runs out of attempts, the code
after the loop is the failure path.

## Step by step
1. Validate the limit first. `[[ $max =~ ^[0-9]+$ ]]` accepts digits only, and
   `(( max < 1 ))` refuses zero:

   ```bash
   if [[ ! $max =~ ^[0-9]+$ ]] || (( max < 1 )); then
     echo "usage: solution.sh MAX" >&2
     exit 2
   fi
   ```
   The `||` short-circuits, so the arithmetic test never sees "lots".

2. The loop, counted from 1 so the messages read naturally:

   ```bash
   for (( attempt = 1; attempt <= max; attempt++ )); do
   ```

3. Run the command as an `if` condition. Its output is silenced; we report
   in our own words. Success ends the script with status 0:

   ```bash
   if lanternpush > /dev/null 2>&1; then
     echo "pushed on attempt $attempt"; exit 0
   fi
   ```

4. Failure: say so and pause, but only if another attempt will follow:

   ```bash
   echo "attempt $attempt failed"
   if (( attempt < max )); then sleep 0.1; fi
   ```

5. After the loop, every attempt has failed: stderr message, `exit 1`.

## Try it by hand
```bash
FAKE_FAILS=2 ./solution.sh 5; cat .push-count    # 3
rm .push-count; FAKE_FAILS=9 ./solution.sh 3     # gives up, count is 3
```

## Alternative
A `while true` loop with a `break` after the limit works as well, but the
counted `for` states the ceiling in its header, where a reviewer looks first.
Real systems often sleep longer after each failure (exponential backoff); the
principle, a bounded number of tries, is the same.

# Walkthrough: The Retry Framework

## The plan
Retrying is easy to write and easy to write badly. A bad retry loop hammers a struggling service, retries things that can never succeed, and waits forever. A good one has a *schedule* (how long to wait), a *limit* (how many tries and how much total waiting), and a *judgement* (which failures are worth another go). We build it as a policy function plus a loop, so the policy can be inspected on its own with a `plan` command.

## Step by step

1. **The schedule.** After the failed attempt number `N`:
   - *fixed* waits the base delay each time: simple, but a crowd of clients retries in lockstep.
   - *linear* waits `delay * N`: 2, 4, 6, ... Gentler on the server as trouble persists.
   - *exponential* waits `delay * 2^(N-1)`: 2, 4, 8, 16, ... The standard because it backs off fast when the outage is long, yet recovers quickly from a short blip.
   Compute exponential by repeated doubling in a loop with an early exit once the value passes the hard limit (86400 s). A bare `1 << n` with a large `n` silently wraps around in 64-bit arithmetic and produces a negative wait.

2. **Cap.** `MAX` bounds a single wait; the hard limit bounds everything. With a cap, exponential becomes "exponential until it hits the ceiling, then constant", which is what you want for a long outage.

3. **`plan`.** A loop from 1 to ATTEMPTS-1 (the last attempt has no wait after it) printing the wait and a total. Having this separate makes the arithmetic testable and lets an operator ask "what will this policy cost me?" before using it.

4. **`run` option parsing.** Options come before `--`; everything after is the command, passed on as `"$@"` so quoting survives. Each value is validated with a regex and a range check; a typo prints the usage and exits 2 rather than falling back to a surprising default.

5. **The loop.** Run the command with `status=0; "$@" || status=$?` so `set -e` does not end the script and the exact status is kept. Then, in order:
   - success: report and exit 0;
   - *not retryable*: exit codes 126 (not executable) and 127 (not found) mean the command itself is wrong, and no amount of waiting fixes that. With `--retry-on` the user can instead name exactly the codes that are transient, such as 7 (cannot connect) or 28 (timeout);
   - last attempt: give up with the command's status;
   - budget: if waiting `W` more seconds would exceed the total budget, stop now rather than start a wait that cannot pay off;
   - otherwise report to stderr, `sleep`, and loop. A wait of 0 skips `sleep` entirely.

6. **Exit status.** The wrapper always exits with the command's last status. Callers can treat the wrapper as transparent: `retry -- curl ...` behaves like `curl ...`, only more patient.

## Complete solution
The schedule function:
```bash
wait_after() {   # STRATEGY DELAY MAX N
  local w i
  case $1 in
    fixed) w=$2 ;;
    linear) w=$(( $2 * $4 )) ;;
    exponential) w=$2; for (( i = 1; i < $4; i++ )); do w=$(( w * 2 )); (( w >= 86400 )) && break; done ;;
  esac
  (( $3 > 0 && w > $3 )) && w=$3
  (( w > 86400 )) && w=86400
  echo "$w"
}
```

## Try it by hand
```bash
./solution.sh plan exponential 6 2
./solution.sh plan linear 5 3 8
FAKE_FAILS=2 ./solution.sh run -- flaky; cat .calls.log
```

## Alternative
Many tools add *jitter*, a random fraction of the wait, so that clients that failed together do not retry together. It is left out here because tests need exact waits, but it is the first thing to add in production: pick a random wait between half and the full computed value.

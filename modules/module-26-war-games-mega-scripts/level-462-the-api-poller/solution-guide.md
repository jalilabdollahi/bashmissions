# Walkthrough: The API Poller

## The plan
Alert fatigue is a design problem, so the script is built around two protections. **Debouncing**:
a new status must be seen N times in a row before it counts, so one flaky response does not
page anyone. **Reliable delivery**: an alert that could not be posted is queued and retried
first thing on the next run, so a webhook outage delays an alert but never deletes it. Both
need memory between runs, which lives in `state/`.

## Step by step
1. **Arguments.** `--webhook URL` (required) and `--confirm N` (positive integer, default 2),
   then exactly one file argument. `^[1-9][0-9]*$` rejects `0` and non-numbers in one test.

2. **Delivery.** `post BODY` is the only place that calls `curl -X POST`. `notify NAME FROM TO`
   builds the JSON with `printf` (the exact bytes matter to the receiver), tries `post`, and on
   failure appends the body to `state/outbox`. It reports `sent` or `queued` through a
   variable, because a function cannot both print for the caller to capture and set status
   lines.

3. **The outbox.** `flush_outbox` runs before polling. It rewrites the queue into
   `outbox.new` containing only the bodies that failed again, then `mv`s it into place. A crash
   in the middle leaves the old queue intact, so the guarantee is "at least once".

4. **Reading a status.** A JSON reply may be pretty printed, so `tr -d '\n'` flattens it and
   `sed -n -E 's/.*"status"...([a-z]+)".*/\1/p'` extracts the value. Anything outside
   `ok`/`degraded`/`down` is `invalid`; a failed `curl` (tested with `if ! body=$(curl ...)`)
   is `unreachable`. Both are real readings that can be confirmed and alerted like any other.

5. **The state machine.** State is `CONFIRMED CANDIDATE COUNT`, with `-` for "none" so `read`
   always finds three fields. Four cases: first ever reading (accept, alert only when it is
   bad); reading equals confirmed (clear any suspicion, this is what makes a flap harmless);
   same candidate again (count up); a different candidate (start counting at one). When the
   count reaches N the change is confirmed, alerted, and the candidate cleared.

6. **Exit status.** `worst=1` whenever the confirmed status of any endpoint is not `ok`, so a
   cron wrapper can tell "all good" from "something is wrong".

## Try it by hand
```
mkdir -p state; ./solution.sh --webhook https://hooks.example/x endpoints.txt
cat state/*.state
```

## Alternative
Alerting on every transition is simpler (three lines less) and is exactly the forty-pages-a-night
design this replaces. Some teams debounce by time instead of count ("down for five minutes");
counting polls needs no clock and is deterministic, which also makes it easy to test.

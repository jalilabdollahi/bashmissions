# Walkthrough: The Canary Releaser

## The plan
A canary release limits the blast radius of a bad deploy. Instead of sending everyone to the new version, you send a small share, check that it behaves like the old one, and grow the share in steps. If any step looks wrong the traffic goes back to zero. In this tool the decisions are made from numbers (requests and errors per step), and the clock and the load balancer are replaced by a `sleep` and an `lbctl` that the tests can record.

The control flow has two kinds of exits. The *good* exit is reaching 100% and promoting. The *bad* exits all funnel into one function, `abort`, so that "something went wrong" always means the same thing: weight 0, an explanation, status 1. The hardest part of rollback code is that it is rarely run, so there should be exactly one copy of it.

## Step by step

1. **Validate everything before acting.** Settings are checked with a regex, files with `-r`, the plan with a loop that insists on strictly increasing steps ending at 100. If the plan is wrong we must find out before the first `lbctl weight 5`, not at step three.

2. **Load the metrics** into four associative arrays keyed by step. Keying by step means order and gaps in the metrics file do not matter, and a missing step is simply an empty lookup.

3. **Integer rates.** Bash has no floating point, but permille (tenths of a percent) keeps one decimal of precision with integers: `errs * 1000 / reqs`. Guard against zero requests, and write a small formatter that turns `25` into `2.5%`. All comparisons use the integer values; only the printing adds the decimal point.

4. **Judge in a sensible order.** First "do we have data at all"; then "enough of it", because a 0-errors rate over 40 requests proves nothing; then the real comparison: the canary may exceed the baseline by at most `TOLERANCE_PM`. Comparing against the live baseline rather than a fixed number matters: during a storm everything fails more often, and a fixed threshold would blame the canary for the weather.

5. **Failure of the tools themselves.** If `lbctl weight` fails we do not know where the traffic is. The safe reaction is a best-effort `weight 0` and a distinct exit status (3), so an operator can tell "the canary was bad" (1) from "the control plane is broken" (3). A failing `promote` is different: all traffic is already on the canary, so rolling back to zero would be the wrong move.

## Complete solution
The core decision:
```bash
crate=$(rate_pm "${c_errs[$step]}" "${c_reqs[$step]}")
brate=$(rate_pm "${b_errs[$step]}" "${b_reqs[$step]}")
limit=$((brate + tolerance))
(( crate > limit )) && abort "$step" "canary $(tenths "$crate") vs baseline $(tenths "$brate") (limit $(tenths "$limit"))"
```

## Try it by hand
```bash
./solution.sh fixtures/plan.txt fixtures/metrics-good.txt v1.5.0
cat .calls.log
SOAK=5 ./solution.sh fixtures/plan.txt fixtures/metrics-bad-at-50.txt v1.5.0; echo $?
```

## Alternative
Real systems compute rates from a monitoring API over a sliding window, and use statistical tests instead of a fixed tolerance. The structure stays the same: shift, soak, measure, decide.

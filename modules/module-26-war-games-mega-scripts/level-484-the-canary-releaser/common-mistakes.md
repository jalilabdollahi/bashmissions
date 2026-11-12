# Common Mistakes

- **Dividing before multiplying.** `$(( errs / reqs * 1000 ))` is 0 for any rate below 100%. Multiply first: `$(( errs * 1000 / reqs ))`.
- **Trusting a tiny sample.** Zero errors in 40 requests passes every threshold. Check the request count before the rate.
- **A fixed error threshold.** "Abort above 1%" blames the canary when the whole fleet is struggling. Compare against the baseline observed at the same step.
- **Rolling back in several places.** One copy of `weight 0` is in the abort function, another in the lbctl error handler with different wording... and one is forgotten in the next feature. Funnel every failure through one function.
- **Validating the plan lazily.** If the 3rd step is malformed and you only notice when you reach it, 50% of traffic is already on the canary. Validate everything first.
- **Letting `set -e` hide the status.** `lbctl weight "$n"` on its own line exits the script with no message and no rollback. Test it with `if !` or `||`.

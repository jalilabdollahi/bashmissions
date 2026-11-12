# Walkthrough: The SLA Monitor

## The plan
An SLA is a promise ("99.9% available"); an **error budget** is that promise turned upside down: 0.1% of the time is *allowed* to be bad, and the budget is how many minutes that is. Gus wants three numbers per service: uptime so far, minutes of budget used, minutes allowed. The probe robot writes one line a minute, so the whole problem reduces to counting minutes carefully.

The subtle design decision is what a missing probe means. If the robot dies, you do not know that the service was up. A conservative monitor counts blind minutes as downtime, which is also what a customer's lawyer would do. That decision is easy to implement if you think of the window as a row of minutes from the first probe to the last: whatever is not a good probe is bad.

## Step by step

1. **Percentages as thousandths.** Bash cannot do `99.9 / 100`. Parse the target with a regex into whole and fractional parts, pad the fraction to three digits, and compute `whole*1000 + frac`. Now 99.9% is the integer 99900, and every later formula is integer maths. (`10#` guards against `08` being read as octal.)

2. **Walk the probes in order.** For each service, remember the last minute seen. A probe at minute `m` after one at `p` implies `m - p - 1` blind minutes: add them to the bad count and to the running streak. Then the probe itself either extends the streak (down) or ends it (up or degraded). A streak that ends increments the outage counter and may become the longest.

3. **Skip, report, continue.** Damaged lines, unknown services and out-of-order probes are reported to stderr with their physical line number, but never stop the report. A monitor that dies on a bad line is blind exactly when logs are messy, which is during an incident.

4. **Close the last streak.** An outage that is still going when the data ends has never seen an up probe to close it, so the report closes it explicitly.

5. **Judge exactly.** `UPTIME = (TOTAL-BAD)*100000/TOTAL` is rounded down for display, but the verdict must not use rounded numbers. A service meets its target when `BAD*100000 <= TOTAL*(100000-T1000)`: pure integers, no rounding, so exactly 5 bad minutes out of 1000 at 99.5% is a pass. `AT RISK` warns while there is still budget: at least 80% used.

6. **Exit status** is 1 if anything is breached, so a cron job or CI step can fail loudly.

## Complete solution
The heart of the per-probe logic:
```bash
gap=$((minute - last[$svc] - 1))
(( gap > 0 )) && { run[$svc]=$((run[$svc] + gap)); bad[$svc]=$((bad[$svc] + gap)); }
if [[ $state == down ]]; then run[$svc]=$((run[$svc]+1)); bad[$svc]=$((bad[$svc]+1)); else close_run "$svc"; fi
```

## Try it by hand
```bash
./solution.sh fixtures/slo.txt fixtures/probes.log; echo "exit $?"
./solution.sh --strict fixtures/slo.txt fixtures/probes.log
```

## Alternative
awk could do the whole job in one pass, but the per-service state, the stderr messages and the exact comparison are easier to read in Bash arrays. For millions of probes you would switch to awk for speed.

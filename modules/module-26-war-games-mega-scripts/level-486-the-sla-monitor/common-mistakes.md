# Common Mistakes

- **Counting only the probes you have.** With 495 probes in a 500-minute window, `up/probes` is 100%. The 5 blind minutes are downtime: derive TOTAL from first and last minute, not from the number of lines.
- **Dividing first.** `$(( up / total * 100000 ))` is 0 or 100000. Multiply, then divide: `up * 100000 / total`.
- **Deciding on the rounded budget.** ALLOWED is truncated for display (`0` for 0.5 minutes), and `bad > allowed` then calls one down minute a breach even when the target technically allows it. Compare `bad*100000` with `total*(100000-target)`.
- **Forgetting to close the last streak.** An outage that lasts until the end of the data never meets an up probe, so `outages` and `longest` miss it. Close it once more before reporting.
- **Octal surprises.** `$(( 08 * 1000 ))` is an error. Strip leading zeros or force decimal with `10#`.
- **Letting one bad line kill the run.** Report it with its line number and carry on; the report is needed most when the logs are messy.

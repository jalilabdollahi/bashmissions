# Common Mistakes

- **Trusting `-checkend` alone.** Wrong: a corrupted or empty `.pem` makes `-checkend` exit 1, so it is reported as EXPIRED and a renewal is attempted. Right: run `-enddate` first; if it fails the file is INVALID.
- **Doing the date maths yourself.** Wrong: `date -d "$notAfter" +%s` (GNU only). Right: `-checkend $((days * 86400))` and read the exit status.
- **Testing the thresholds in the wrong order.** Wrong: checking the warn window first, so everything near expiry is only WARN. Right: strictest first: now, then crit, then warn.
- **Counting only successes against the limit.** Wrong: `max` applies to successful renewals, so a dead CA gets hit for every certificate. Right: count attempts.
- **Reloading inside the loop.** Wrong: `systemctl reload nginx` after each certificate. Right: set a flag and reload once after the loop.
- **Reporting the old expiry.** Wrong: printing the values read before the renewal. Right: call `inspect` again after a successful renewal.

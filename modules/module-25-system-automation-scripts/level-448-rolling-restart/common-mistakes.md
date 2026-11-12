# Common Mistakes

- **Restarting everything in parallel.** `for h in ...; do ssh "$h" ... & done` restarts the whole tier at once; the load balancer has nobody left.
  - Right: sequential loop, health gate in between.
- **Trusting the restart's exit status as proof of health.** A unit can accept `restart` and fail two seconds later.
  - Right: poll `systemctl is-active` afterwards.
- **Unbounded waiting.** `until [[ $(ssh ... is-active) == active ]]; do :; done` spins forever on a broken host.
  - Right: a fixed number of checks, then abort.
- **Aborting without saying what was left.** "restart failed" does not tell the on-call engineer which hosts still run the old config.
  - Right: report the untouched count (or list) in the abort message.
- **`state=$(ssh ... is-active)` under `set -e`.** The non-zero status of an inactive unit ends the script before you can retry.
  - Right: `state=$(...) || true`

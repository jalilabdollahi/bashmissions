# Walkthrough: The Self-Healing Script

## The plan
Self-healing automation is the unglamorous heart of operations: take the fixes a human would apply anyway, apply them in order from least to most disruptive, and *verify after each one*. The interesting design is in what stops the loop. A healer without limits is dangerous: it can restart a database that is down for a reason a restart cannot fix, hammer a failing dependency, or hide a recurring fault by fixing it silently every night. This script has three guardrails: an action budget per run, flap detection across runs, and a single-instance lock.

## Step by step

1. **Validate first.** Settings are checked, the playbook is parsed completely and every action name verified before the first `svcctl` call. If line 7 of the playbook has a typo, you want to hear it before line 1 has been acted on.

2. **Lock.** `mkdir "$state.lock"` succeeds for exactly one process. The `trap ... EXIT` releases it on success, on `exit 1`, and when `set -e` aborts the script. Take the lock *after* validation, so a bad playbook never leaves one behind, and before reading the state, so no other healer can change it underneath you.

3. **Detect.** The exit status of `svcctl status` has three meanings: 0 healthy, 3 unknown service, other sick. `rc=0; cmd || rc=$?` records it without triggering `set -e`. A healthy service resets its counter, because the counter means "runs in a row that needed a heal".

4. **Flapping.** A service healed in each of the last three runs is not healthy; it is broken and being propped up. At or above the limit the script stops fixing it and pages instead. This is why the counter lives in a file: one run alone cannot see a pattern.

5. **Remediate and verify.** Each action is followed by `sleep GRACE` (give the service time) and a fresh status check. The first action that makes the status healthy ends the loop and its name goes in the report, together with the attempt number. Before running each action the script compares the global `used` count with `MAX_ACTIONS`: when the budget is gone the remaining services are *skipped*, not paged, because the problem is the script's limit, not necessarily the service.

6. **Escalate.** If every action fails, `pagerctl notify` wakes a human with the number of actions that were tried. Failures are counted for the exit status.

7. **Persist.** Counters are written sorted so the file is stable and diffable.

## Complete solution
The heart of the loop:
```bash
for action in ${plan[$svc]}; do
  (( used >= max_actions )) && { skipped=1; break; }
  svcctl "$action" "$svc"
  used=$((used + 1)); attempts=$((attempts + 1))
  sleep "$grace"
  if svcctl status "$svc" >/dev/null 2>&1; then healed=1; break; fi
done
```

## Try it by hand
```bash
mkdir svc; echo down > svc/web; echo restart > svc/web.fix
printf 'web restart,clear-cache\n' > playbook.txt
./solution.sh playbook.txt state.db; cat state.db .calls.log
```

## Alternative
systemd's `Restart=on-failure` with `StartLimitBurst` implements the same ideas natively: restart, wait, give up after N tries. A custom script earns its place when the remedies go beyond "restart", like clearing a cache or failing over first.

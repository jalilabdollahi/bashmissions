# Walkthrough: The Ultimate Deployer

## The plan
GitOps means the *repository* is the source of truth and a reconciler makes reality match it. The reconciler never asks "what command should I run?"; it asks "what differs between desired and live, and how do I close the gap safely?". That question has four parts: guards (should I act at all?), a plan (what differs?), execution with verification (apply, check, undo on failure) and a record (what did I do, at which commit?).

The script is long, but each part is small and uses an idea from earlier in this module: the freeze and the lock are guards, validation is "parse everything, report everything", the plan is data in associative arrays, the loop is the canary's apply-verify-rollback, the budget is the rate limiter's idea applied to change, and the audit line ties a change to a commit.

## Step by step

1. **Guards, in a deliberate order.** A freeze is checked first and costs nothing. The lock comes next (`mkdir` is atomic; a `trap` releases it on every exit path, including errors from `set -e`). Only then do we pull, because pulling changes the repository the next deploy would read, and we want to do it exactly once under the lock. If the pull fails we stop: deploying a stale working copy is worse than deploying nothing.

2. **Validate before acting.** All manifests are read; each problem is reported with the file name and line meaning; only after the whole directory has been checked does the script exit 2. The decisive property is that a typo in the eighth manifest can never leave the first seven applied.

3. **Plan as data.** Desired values go in `dver`, `drep`, `dport`, `dorder`; live values in `lver`, `lrep`, `lport`. `action_of` classifies an app: create, update or unchanged. Orphans are names with a state file and no manifest; by default they are only reported, because deleting on a typo is the classic GitOps disaster, so removal needs `--prune`.

4. **Budget.** If the plan changes more than `MAX_CHANGES` things, refuse. A bad merge that rewrites forty manifests should ask a human, not be applied. The dry run warns instead of refusing so you can see what would happen.

5. **Apply, verify, undo.** For every change: `deployctl apply`; if it fails, record `failed` and move on. Otherwise ask `healthctl`. Only a healthy app gets its state file written, so the state file is always "last known good". Unhealthy: a new app is removed again; an updated app is re-applied at its old version using the *old* replicas and port, which is why the old values were kept in separate arrays and the state file was not touched.

6. **Audit and report.** Each outcome appends one line with the time, the short commit hash, the action and the result, so the log answers "what changed, when, from which commit". The summary is a single line; any rollback or failure also sends a notification and exits 1.

7. **Dry run.** The same code path computes the same plan; the apply step is replaced by "would ..." lines and nothing is written, audited or called. Because the plan code is shared, the preview cannot drift from reality.

## Complete solution
The heart of the loop:
```bash
rc=0; deployctl apply "$n" "${dver[$n]}" "${drep[$n]}" "${dport[$n]}" || rc=$?
if (( rc != 0 )); then echo "FAILED $n (deployctl exit $rc)"; ...; continue; fi
if healthctl "$n"; then
  write_state "$n"
else
  if [[ $act == create ]]; then deployctl remove "$n"
  else deployctl apply "$n" "${lver[$n]}" "${lrep[$n]}" "${lport[$n]}"; fi
fi
```

## Try it by hand
Create `repo/apps/db.app` (`version=1.0.0`), an empty `live/` folder, then:
```bash
./solution.sh --dry-run repo live 1700000000
./solution.sh repo live 1700000000
cat live/audit.log live/db.state
```
(`git`, `deployctl`, `healthctl` and `notifyctl` are stubs in the tests.)

## Alternative
Real GitOps tools (Argo CD, Flux) run this loop continuously and compare full cluster objects. This script is the same reconciler run once per invocation, which is why it fits a cron job or a CI step.

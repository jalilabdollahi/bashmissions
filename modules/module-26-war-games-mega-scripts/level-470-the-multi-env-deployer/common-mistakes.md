# Common Mistakes

- **Stopping at the first failed gate.** Wrong: `exit 1` inside the loop, so the user fixes one problem and meets the next on the following run. Right: count failures, print every gate, decide at the end.
- **Letting the user type the version.** Wrong: `promote APP 2.4.1 prod` can ship something that was never in staging. Right: read the version from the source environment's state.
- **Allowing skipped environments.** Wrong: accepting any FROM/TO pair. Right: require `index(TO) == index(FROM) + 1`.
- **Recording state before the health check.** Wrong: writing `prod.version` right after `push`. A failed deploy then claims success. Right: write state after `health: ok`.
- **Self-approval.** Wrong: only checking that an approval file exists. Right: compare the approver with `${DEPLOYER:-$USER}`.
- **A fatal error on a missing state file.** Wrong: `cat state/x.version` under `set -e` kills `status` for a fresh environment. Right: `[[ -f $f ]] && cat "$f" || true`.

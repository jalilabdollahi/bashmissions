# Common Mistakes

- **Reading the old target too late.** Wrong: `ln -sfn ... current; previous=$(readlink current)` records the new release. Right: read first, switch after.
- **Forgetting `-n`.** Wrong: `ln -sf releases/v2 current` when `current` is a link to a directory creates `releases/v1/v2`. Right: `ln -sfn releases/v2 current`.
- **Forgetting the first deploy.** Wrong: running `readlink current` with no link kills the script under `set -e`, or restores an empty target. Right: test `[[ -L current ]]` and handle "no previous".
- **Letting the smoke test end the script.** Wrong: a bare `smoke-test` under `set -e` exits before the rollback runs. Right: `rc=0; smoke-test || rc=$?`.
- **Reporting success after a rollback.** Wrong: exit 0 once the old release is back, so the pipeline looks green. Right: exit 1; the deploy still failed.

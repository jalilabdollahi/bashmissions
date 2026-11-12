# Common Mistakes

- **Not verifying after the action.** `svcctl restart web; echo healed` reports success for a restart that did nothing. Re-check the status and report what you observed.
- **An unbounded retry loop.** `until healthy; do restart; done` never ends if the cause is not restart-shaped, and it can take a struggling dependency down with it. Bound the actions per service and per run.
- **Letting `set -e` hide the exit status.** `svcctl status "$svc"` on its own line kills the script for any sick service. Use `rc=0; svcctl status "$svc" || rc=$?`.
- **Resetting the flap counter at the wrong time.** Reset it when a run finds the service healthy; do not reset it after a heal, otherwise a service that is healed every run never looks flappy.
- **Taking the lock before validating, and no trap.** A typo in the playbook leaves `state.lock` behind, and every later run says "another healer is running". Validate first, trap the cleanup.
- **Paging for a skipped service.** Running out of the action budget is a decision of the script, not a diagnosis of the service. Report it as skipped and let the next run continue.

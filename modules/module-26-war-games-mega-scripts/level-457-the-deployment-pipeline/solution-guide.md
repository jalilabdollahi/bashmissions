# Walkthrough: The Deployment Pipeline

## The plan
A pipeline is a short list of stages with one rule about what a failure means.
Before anything is live (build, test) a failure simply stops the run. Once the
deploy stage has started, the world has changed, so a failure there, or a failed
health check afterwards, must put the old version back. Everything else is
bookkeeping: a lock so two pipelines cannot fight over one app, a log so Mara can
reconstruct what happened, and exit codes that say which stage broke.

## Step by step
1. **Arguments first.** Two arguments, and the version must match
   `^[0-9]+\.[0-9]+\.[0-9]+$` with `[[ =~ ]]`. Both problems are usage errors, exit 2.

2. **Lock before trap.** Check `[[ -e $lock ]]` and refuse with exit 7. Only after
   that create the lock and register `trap 'rm -f "$lock"' EXIT`. The order matters:
   a trap registered earlier would delete the running pipeline's lock when the
   second invocation bails out. The EXIT trap also fires on `exit 3`, `exit 5`
   and on `set -e` aborts, so you never write cleanup twice.

3. **Previous version.** `previous=none`, then read `state/$app.version` if it
   exists. Read it now, before the deploy: after a successful run the file is
   overwritten and the information is gone.

4. **`run_stage`.** One function that takes the stage name and the command:

   ```bash
   run_stage() {
     local name=$1; shift
     if "$@" >/dev/null 2>&1; then echo "stage $name: ok"; log_stage "$name" ok
     else echo "stage $name: FAILED"; log_stage "$name" fail; return 1; fi
   }
   ```
   It is called inside an `if`, which is also what keeps `set -e` from killing the
   script at the first failing stage.

5. **`verify`.** A `for attempt in 1 2 3` loop around `harbor-health`. The pause
   only belongs between attempts, so test `(( attempt < 3 ))` before `sleep 5`.

6. **`rollback`.** No previous version means there is nothing to go back to: say so
   and exit 6 (the trap still runs). Otherwise redeploy the previous version and
   tell the operator.

7. **Wiring.** Build then test with their own exit codes. For the last two stages
   use `if ! run_stage deploy ... || ! verify; then rollback; ...; exit 5; fi`.
   Because `||` short-circuits, verify never runs when the deploy itself failed.
   Only a fully green run reaches the line that records the new version.

## Try it by hand
```
mkdir -p state; echo 2.3.9 > state/shrimp-api.version
./solution.sh shrimp-api 2.4.0
cat state/pipeline.log
```

## Alternative
You could write the stages as a list (`stages=(build test deploy verify)`) and
loop over them with a `case`. That scales better to ten stages, but here each
stage has a different failure policy, so explicit calls read more clearly.
Another trap-free option is to remove the lock manually before every `exit`;
it works until someone adds a new exit path and forgets.

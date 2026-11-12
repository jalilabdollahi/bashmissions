# Debrief: The Deployment Pipeline

A deployment script is really a **state machine with a safety net**. You had
four stages, but the interesting design was the *policy*: failures before the
deploy cost nothing, failures after it demand a rollback. Writing that policy
once, in one place, is what separates a pipeline from a pile of commands.

Under the hood three Bash features did the heavy lifting. `trap ... EXIT` runs
in every way a script can end, so the lock is released after success, after
`exit 5`, and after a `set -e` abort. Putting a command inside an `if` suspends
`set -e` for that command, which lets you decide what a failure means instead of
letting the shell decide. And reading the previous version *before* the deploy
captured information that the successful run is about to destroy.

In real work this exact shape shows up everywhere: CI jobs, Kubernetes rollout
scripts, database migrations with a down step. The names change, the idea does
not: remember how to get back before you move forward, check the result with a
real probe, and make the failure loud and specific with its own exit code.

Going further: the next missions reuse these habits (strict mode, traps, state
in files) while you turn raw logs into an incident timeline.

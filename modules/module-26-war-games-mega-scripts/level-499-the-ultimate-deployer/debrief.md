# Debrief: The Ultimate Deployer

This is the shape of modern deployment: **declare, diff, apply, verify, record**. Git holds the declaration, so every change to production has an author, a review and a history. The reconciler computes the difference and closes it. And because it re-checks reality every run, it also repairs drift: a manifest that says version 1.5.0 wins over someone's hand-edit.

The script is long because production is full of ways to go wrong, and each guard answers one of them. A freeze answers "not now". The lock answers "not twice". Pulling under the lock answers "not stale". Validating everything first answers "not half". The change budget answers "not too much". Health checks and rollback answer "not broken". The audit line answers "who, what, when". Pruning behind a flag answers "not by accident". None is clever; the skill is remembering all of them, in the right order.

Notice how much of the module this single script reuses: atomic `mkdir` locks, a validated config, a plan computed as data, a canary-style apply-verify-undo loop, a retry-free fast failure, an append-only audit trail and a notification on trouble. That is how real tools are built: not from one big idea but from many small, well-tested ones.

You also practised keeping the *old* value around before you change anything. Rollback is trivial if you never overwrote what you need to go back to.

Going further: one mission is left. Put the toolkit together under one command, and hand the pager to its new owner.

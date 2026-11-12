# Debrief: The Migration Runner

Migrations are version control for state. A folder of numbered files is the history, the ledger is "where this particular database is", and the runner's job is to move one to the other safely. The same pattern appears in database tooling, in configuration management and in any system that must evolve without a rebuild.

The design had three promises. **Once**: the ledger makes running `up` repeatedly harmless. **In order**: ids are applied ascending, and an older pending id is refused because it would run in an order that other servers never saw. **As written**: the fingerprint of each applied file turns a quiet edit into a loud error. If a change needs fixing, you write a *new* migration. This is the same reasoning as git's immutable commits.

The failure behaviour matters as much as the happy path. Recording success *after* each step and stopping at the first failure makes the operation resumable: fix the problem, run `up` again, and it carries on exactly where it stopped. A runner that records everything at the end loses its place when it crashes; one that records before the work lies about the state.

Look back at the module: the ledger is a persisted state file like the circuit breaker's, the fingerprints echo the audit trail and the evidence collector, and `refusing to migrate` is the safety-first posture of the compliance enforcer. Real tools are mostly these small ideas in combination.

Going further: the next mission is the deploy that uses everything: a GitOps-style rollout that reads desired state, applies it, checks it, and reverts on failure.

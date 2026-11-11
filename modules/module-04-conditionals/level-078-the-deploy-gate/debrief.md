# Debrief: The Deploy Gate

Real decisions are rarely one question. They are trees: answer the broad
question first, and let the answer decide which narrower question comes next.
A nested `if` is how you write that. Each level of indentation means "we are
now inside the case where the outer condition held".

## Under the hood

Nothing new happens at runtime: each `if` is a command with an exit status,
and a nested `if` is just one more command inside a branch. What changes is
how you design it. The tools from this module combined here: a count check
(`$#`), string tests (`!=`, `==`), the logical operators (`&&` in the guard), a
file test (`-e`), and an arithmetic test (`(( ))`). Each guard clause removes a
class of bad input early, so inner levels stay short.

If the nesting gets deeper than three levels, that is a hint to step back. Move
checks that apply to all cases up into guards, or split the logic into functions
(a Module 9 topic). Order matters: the policy lists "tests" before "freeze"
before "approvals", so a freeze with missing approvals reports the freeze, not
the approvals.

## Where it shows up

CI/CD pipelines, release checklists, access control, feature flags, and any
runbook whose steps say "if X, then check Y".

## Going further

Module 5 is about repetition. You will gate not one deploy but fifty servers,
using loops. Every decision you wrote here becomes the body of a loop.

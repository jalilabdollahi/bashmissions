# Debrief: Promote Between Environments

The mental model: **a promotion moves one tested artifact forward through
gates; it never rebuilds and never skips.** Encoding the rules in a script
means the safety does not rely on someone remembering Priya's checklist at
17:55 on a Friday.

Three ideas carry the design. First, order as data: the `stages` array makes
"the next environment" an index calculation, so the rule set stays the same if
a `canary` stage is added. Second, ordered checks before action: the cheapest and
most structural checks (names, adjacency) come first, then state, then policy
(approval), then the deploy. Each failure has its own message and exit code so
the pipeline log tells the story. Third, record after success: if the state file
changed before the deploy and the deploy failed, every later run would believe
a lie.

The downgrade rule shows why version comparison must be numeric. As text,
`1.9.0` sorts after `1.10.0`; splitting on dots and comparing integers gets it
right, and works without `sort -V`, which older systems lack.

The same structure appears in GitHub Environments with required reviewers, Argo
CD promotion flows and release trains.

Going further: some of these jobs run unattended. The next level wraps a command
so that cron can run it safely, once at a time, with a log.

# Debrief: Idempotent Scripts

An operation is *idempotent* when doing it twice has the same effect as doing it once.
`mkdir -p` is; `echo x >> file` is not. Scripts that change systems (provisioning,
deployment, cron jobs) will be run again, after a failure, by a colleague, by a timer,
by a retry. If the second run breaks something or doubles it, the script is
operationally unsafe, however correct the first run was.

The mental model is to declare the end state and converge on it. For each piece of
state ask three questions: how do I test whether it is already right, how do I make
it right, and what must I never touch? The test usually already exists in the shell:
`[ -d ]`, `[ -e ]`, `grep -qxF`, `cmp -s`. For anything that edits a file shared with
other writers, the test and the append are two separate moments; that gap is why serious
tools use locks, but for a single-operator script the check-then-act pattern is the
right size.

Partial failures are the reason this matters. If step 2 failed last time, a re-run
must pick up at step 2 without redoing or damaging step 1. The "half finished" test case
in this level is exactly that situation, and it is the one real incidents are made of.

Going further: scripts you can re-run are also scripts you can *source* in tests, if the
file is both a library and a program. That is level 287.

# Debrief: The Self-Healing Script

Automation that acts on production needs more engineering in its restraint than in its action. The fixes here are one-liners; the value is in the rules around them: verify after every action, escalate in order, cap the total, notice patterns, take a lock, and tell a human when you give up.

The shape you used is the control loop at the heart of Kubernetes, autoscalers and every thermostat: observe, compare with the desired state, act, observe again. What turns a naive loop into an operable one is the set of brakes. The action budget stops a bad night from becoming a restart storm that makes things worse. The flap counter converts "fixed it again" into "this needs a real fix" and wakes a human. The lock keeps two copies of the healer, perhaps one started by cron and one by a person, from interfering.

Two shell techniques are worth remembering. `rc=0; cmd || rc=$?` is the safe way to capture an exit status under `set -e` and to distinguish several failure meanings. And a `trap ... EXIT` combined with an atomic `mkdir` gives you cleanup that runs on every path out of the script.

Going further: a healer repairs one service. How do you repair a *graph* of services that depend on each other? You need to know the order: the dependency graph, next.

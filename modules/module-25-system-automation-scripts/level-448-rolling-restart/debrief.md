# Debrief: Rolling Restart

## What you learned

Serial rollouts with a health gate are how fleets change without downtime. The ideas generalise: act on a small slice, verify, continue, and on the first sign of trouble stop with the rest untouched. The abort message that says how many hosts were left alone is what an on-call engineer needs at 2 a.m.

## Under the hood

Restart returning success only means systemd accepted the request. The service may still be starting, or may crash a second later, so the gate asks for the state afterwards. `is-active` signals state through both its text and its exit status, which is why the script combines `|| true` (do not die on non-zero) with an explicit comparison.

The retry loop is bounded on purpose. An unbounded "wait until healthy" is a script that hangs forever on the first broken host, holding the whole maintenance window hostage. In a real script you would also sleep between checks and use a timeout such as `ConnectTimeout`.

## In real work

Orchestrators add batch sizes (restart 10% at a time), automatic rollback and notifications. The load balancer is usually told to drain a host before the restart. All of them are elaborations of the loop you wrote.

## Going further

Not everything on a host is a service: databases need careful, periodic snapshots. Next you will rotate database dumps.

# Walkthrough: Rolling Restart

## The plan

A rolling restart trades speed for safety. At every moment at most one host is
out of service, and the rollout only advances once the previous host has
shown it is healthy. If any step fails the right move is to stop and leave the
remaining hosts running the old, known-good version.

## Building it

Validate the service name with a regex: it ends up in a command run on remote
machines, so only plain unit-name characters are allowed.

Read the host file into an array first. A streaming loop would work for the
restarts, but the abort message needs "how many hosts were left untouched",
and that requires knowing the total up front. With an index `i`, the hosts
after the current one number `${#hosts[@]} - i - 1`.

Write an `abort INDEX REASON` function that prints the message to stderr and
exits 1. Both failure paths call it, so the message format lives in one place.

For each host: print, then restart with `ssh -n -o BatchMode=yes`. Putting
`|| abort "$i" "restart failed"` after the command handles failure, and, as a
command in an `||` list, it does not trip `set -e`.

The health gate is a bounded loop of three checks. `systemctl is-active`
prints the state and exits non-zero for anything but `active`; capture the
output and neutralise the status with `|| true`, then compare the text. On
success print how many checks it took and `break`. If no check succeeded
(`healthy` is still 0) abort with the last state you saw.

## Complete solution

See answer.sh.

## Trying it by hand

```
printf 'anchovy\ndory\n' > web.txt
FAKE_BROKEN=dory ./solution.sh web.txt nginx; echo "exit $?"
cat .calls.log
```

## Alternative

Restart everything first and check afterwards. It is simpler and finishes
faster, and it is exactly what the story warns against.

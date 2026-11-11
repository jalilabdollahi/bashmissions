# Walkthrough: Watchdog Restart

## The plan
A watchdog is a small loop with a memory-less routine for each service:
*detect*, *act once*, *verify*, *report*. The script never assumes the restart
worked; it asks again. And it never gives up on the rest of the list because
one service is stubborn.

## Step by step
1. Refuse to run with no service names (exit 2).

2. Detect using the exit status, not the printed word. `systemctl is-active`
   prints `active` or `inactive`, but its exit status (0 or non-zero) is the
   reliable part, and `if` reads it directly. The printed word is thrown away
   with `> /dev/null`:

   ```bash
   if systemctl is-active "$svc" > /dev/null; then
     echo "ok $svc"
     continue
   fi
   ```

3. Act exactly once and verify. `&&` chains the two commands, so the "then"
   branch only runs if the restart succeeded *and* the service answers as
   active afterwards:

   ```bash
   if systemctl restart "$svc" && systemctl is-active "$svc" > /dev/null; then
     echo "restarted $svc"
   else
     echo "FAILED $svc"
     failed=1
   fi
   ```

   Commands tested by `if` never trigger `set -e`, so a failing restart is
   something you handle, not a crash.

4. Keep a `failed` flag and end with `exit "$failed"`. The loop visits every
   service first.

## Try it by hand
```
FAKE_ACTIVE="nginx" ./solution.sh nginx postfix
FAKE_RESTART_FAIL="postfix" ./solution.sh postfix; echo $?
cat .calls.log
```

## Alternative
A `while` loop that retries until the service is up looks tempting, but a service
that cannot start would be hammered forever, and might hide a real fault.
One restart and an honest report is what a human on call would do too.

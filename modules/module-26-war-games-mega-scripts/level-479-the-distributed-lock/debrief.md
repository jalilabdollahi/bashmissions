# Debrief: The Distributed Lock

You built mutual exclusion out of a single filesystem guarantee. `mkdir` is a test-and-set in one system call: it checks that the name is free and creates it, and nothing can happen in between. Every lock in every system, from `flock` to a database row, rests on the same idea: one atomic step that only one contender can win.

Under the hood, the interesting part is not taking the lock but losing it gracefully. A process can crash, be killed by the OOM killer or lose its network, and a lock that waits for a polite release would stay forever. Expiry fixes that, at a price: if the holder is only slow, not dead, two processes can believe they hold the lock. That is why the owner can renew, why releases check the owner, and why real systems add "fencing tokens". Your script also treats half-written metadata as busy, which is the safe default when you cannot tell.

Injecting `NOW` instead of reading the clock is a design habit worth keeping. The script became a pure function of its inputs, so the exact moment of expiry could be tested with no sleeping and no flakiness.

You will meet this pattern in deploy tools, cron wrappers ("do not start if the last run is still going") and package managers' lock files.

Going further: the next missions build on the same discipline of explicit state and explicit time. The rate limiter keeps a bucket in a file and also takes its clock from the caller.

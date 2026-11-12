# Walkthrough: The Distributed Lock

## The plan
A lock needs three properties: only one winner, a name for the winner, and a way out when the winner dies. `mkdir` gives the first one for free, because the kernel guarantees that of any number of simultaneous `mkdir` calls on the same path exactly one succeeds. Two small files inside the directory give the second and third: `owner` and `expires`. Because tests (and good design) should not depend on the wall clock, the current time arrives as the argument `NOW`, which turns "is this lock stale?" into plain integer arithmetic.

## Step by step

1. **Validate first.** `TTL` and `NOW` must be positive integers. A regex test `[[ $1 =~ ^[1-9][0-9]*$ ]]` is enough, and it protects the later `$(( ))` from text like `soon`, which Bash would silently evaluate as a variable name.

2. **Read the holder in one place.** `load_holder` fills `holder` and `expires` and returns failure if either file is missing or the deadline is not a number. This matters: between `mkdir` and the moment the owner file is written there is a tiny window where the lock exists but is empty. A cautious script treats that as "busy", never as "stale", otherwise two processes could both believe they hold the lock.

3. **Acquire.** Try `mkdir "$lock" 2>/dev/null`. If it succeeds, write the files and report. If it fails, find out why: no directory at all means a different problem (missing parent), exit 2. A directory with damaged metadata means busy. A readable deadline in the future means either a renewal (same owner) or `busy` with the seconds remaining. A deadline at or before NOW means the owner is gone: announce the reclaim, delete the files and directory, and run `mkdir` again. That second `mkdir` can fail if another reclaimer was quicker, and the script must accept that and report busy.

4. **Release.** Refuse to touch a lock that belongs to someone else (exit 3, so callers can tell it from "not locked", exit 1). Removing the files first and `rmdir` last is deliberate: `rmdir` refuses to delete a non-empty directory, so a concurrent writer cannot be silently destroyed by it.

5. **Status.** Three outcomes, one line, always exit 0, so dashboards can poll it.

## Complete solution
See `answer.sh` in the level folder after you pass, or compare these key parts:

```bash
if mkdir "$lock" 2>/dev/null; then
  write_meta "$lock" "$owner" "$until"
  echo "acquired $lock by $owner until $until"
elif load_holder "$lock" && (( expires > now )); then
  # renew or busy
else
  # stale or half-written
fi
```

## Try it by hand
```bash
mkdir -p locks
./solution.sh acquire locks/deploy.lock mara 300 1700000000
./solution.sh status  locks/deploy.lock 1700000100
./solution.sh acquire locks/deploy.lock theo 60 1700000100   # busy
./solution.sh acquire locks/deploy.lock theo 60 1700000400   # reclaimed
```

## Alternative
`flock` is the textbook answer on Linux, but it locks a file descriptor, is missing on macOS, and does not survive an NFS mount. A lock directory works everywhere and is visible to a human with `ls`. The price is that you must write the expiry logic yourself, which is exactly what this mission practises.

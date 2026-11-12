# Walkthrough: Cron Wrapper

## The plan
Cron's contract is tiny: start this command at this time. Everything else that
makes a scheduled job reliable (overlap protection, logs, an honest exit
status) is your job. Put it in one wrapper so no cron entry has to reinvent it:

    0 2 * * *  solution.sh nightly-backup /opt/backup.sh --full

## Steps
Validate first, then `shift` the NAME away. From then on `"$@"` is exactly the
command with its arguments, ready to run safely with every word intact:

```bash
name=${1:-}
[[ $name =~ ^[A-Za-z0-9_-]+$ ]] && (( $# >= 2 )) || { usage; exit 2; }
shift
```

The name is restricted because it becomes part of a path: `../evil` would escape
the `locks` folder.

The lock is a directory. `mkdir` is atomic at the filesystem level: of two
simultaneous callers one succeeds and one gets an error. That is
something `[[ -e lockfile ]] && ...; touch lockfile` cannot promise, since another
run can slip in between the test and the touch.

```bash
if ! mkdir "$lock" 2>/dev/null; then
  echo "[$name] skipped: previous run still active" >> "$log"
  exit 0
fi
```

The skipped run exits *before* any trap exists, so it cannot delete the lock
that belongs to the running job. After a successful `mkdir`, install the trap:

```bash
trap 'rmdir "$lock"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
```

An EXIT trap runs on normal exit, on `exit N` and on `set -e` failures. Signals
need turning into a normal exit so that the EXIT trap fires.

Finally run the job and keep its status, redirecting both streams into the log:

```bash
rc=0
"$@" >> "$log" 2>&1 || rc=$?
echo "[$name] finish: exit $rc" >> "$log"
exit "$rc"
```

## Try it by hand
```bash
./solution.sh demo bash -c 'echo hi; exit 4'; echo "exit $?"
cat logs/demo.log; ls locks
```

## Alternative
`flock` gives kernel-managed locks that vanish with the process, but it is not
available on macOS. The mkdir lock is portable, at the cost that a `kill -9`
leaves a stale lock to clear by hand.

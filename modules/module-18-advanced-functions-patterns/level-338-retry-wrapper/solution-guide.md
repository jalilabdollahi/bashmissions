# Walkthrough: Retry Wrapper

## The plan

`retry` is a function whose first argument is *configuration* (how many times)
and whose remaining arguments are the *job*. After one `shift`, `"$@"` is the
job, and it can be run as often as needed. Everything else is careful
bookkeeping around that call.

## Step by step

Take the count and drop it from the list:

```bash
retry() {
  local max=$1 attempt=1 rc=0
  shift
```

Run the job so that failure is an answer, not a crash. With `set -e` a failing
command ends the script, but a command that is the left side of `||` is
exempt, and `rc=$?` records the status:

```bash
  while true; do
    rc=0
    "$@" || rc=$?
```

On success, return. On failure, report; if that was the last attempt, say so and
hand back the *job's* status so callers can tell what went wrong (7 is not 1):

```bash
    (( rc == 0 )) && return 0
    echo "retry: attempt $attempt/$max failed (status $rc)" >&2
    if (( attempt >= max )); then
      echo "retry: giving up" >&2
      return "$rc"
    fi
    sleep "${RETRY_DELAY:-0}"
    attempt=$(( attempt + 1 ))
  done
}
```

No sleep after the last failure: there is nothing to wait for.

The caller part validates the arguments first. The check is ordered so that the
arithmetic only sees a number: at least two arguments, a regex test, then the
comparison with 1. Finally capture and forward the status the same way:

```bash
status=0
retry "$@" || status=$?
exit "$status"
```

## Try it by hand

```
FLAKY_FAILS=2 ./solution.sh 4 flaky sync "tidewater books"
./solution.sh 2 false; echo "exit=$?"
cat .flaky-count
```

## Alternative

An `until "$@"; do ...` loop is more compact, but it hides the status of the
last failure (inside the loop `$?` is already the result of the test), which
is why a explicit `rc` variable is clearer here.

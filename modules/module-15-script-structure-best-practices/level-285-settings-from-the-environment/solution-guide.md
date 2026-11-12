# Walkthrough: Settings from the Environment

## The plan
Read each variable once, near the top, into a plain variable with its default. Then
validate in the order the spec gives, and only then use the values.

## Steps
1. A small helper for the failure path, so all three messages share one exit:
   ```bash
   die() { echo "solution.sh: $1" >&2; exit 2; }
   ```
2. Read with defaults:
   ```bash
   host=${POLL_HOST:-}
   seconds=${POLL_SECONDS:-30}
   mode=${POLL_MODE:-normal}
   ```
   `:-` fires when the variable is unset *or empty*, which matches the rule "empty
   means not given". Plain `${VAR-default}` (no colon) would only fire for unset.
3. Host: `[ -n "$host" ] || die "POLL_HOST is required"`. The `:-` in step 2 is what
   stops `set -u` from aborting on a missing variable before we can print our message.
4. Seconds: first the shape, then the range. The `||` short-circuits, so the
   arithmetic only runs on digits:
   ```bash
   if ! [[ $seconds =~ ^[0-9]{1,5}$ ]] || (( 10#$seconds < 1 || 10#$seconds > 3600 )); then
   ```
5. Mode: a `case` with the allowed words and a catch-all that dies.

## Try it
```
POLL_HOST=anchovy ./solution.sh
POLL_HOST=anchovy POLL_SECONDS=abc ./solution.sh; echo $?
POLL_SECONDS=5 ./solution.sh      # host missing
```

## Alternative
`${POLL_HOST:?POLL_HOST is required}` stops with a message in one expression, but the
text bash prints includes the script name and line number, and the exit status is
not under your control. For a tool people run daily, your own `die` reads better.

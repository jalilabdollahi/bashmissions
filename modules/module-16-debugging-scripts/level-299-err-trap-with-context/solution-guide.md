# Walkthrough: ERR Trap with Context

## The plan
When a command fails, Bash can run a handler. The handler runs *in the context
of the failure*, so the special variables still describe it. We print three of
them in a fixed shape, and let `set -e` end the script with the right status.

## Step by step
1. Run the starter with `HC_RC=3 ./solution.sh eel`. The script stops, silently,
   with status 3. That is the 3 a.m. problem.

2. Change `set -e` to `set -eE`. Without the capital E, an ERR trap set at the
   top level is *not* inherited by shell functions, and the failure inside
   `publish` would go unreported.

3. Register the trap before `publish` runs:

   ```bash
   trap 'status=$?; echo "failed: $BASH_COMMAND (status $status) at line $LINENO" >&2' ERR
   ```

   - `$?` is the failing command's status; copy it into `status` first, because
     running anything (even `echo`) replaces `$?`.
   - `$BASH_COMMAND` is the command text as written: `healthcheck "$1"`.
   - `$LINENO` is the line of the failing command.
   - Single quotes delay all of that until the trap fires.

4. Try the three situations:

   ```
   $ HC_RC=3 ./solution.sh eel
   failed: healthcheck "$1" (status 3) at line 6
   $ echo $?
   3
   ```

   The line is inside `publish`, where the command is, not where `publish` was
   called.

## Complete solution
```bash
#!/usr/bin/env bash
set -eE
publish() {
  healthcheck "$1"
  echo "healthy: $1"
  restart-site "$1"
  echo "restarted: $1"
}
trap 'status=$?; echo "failed: $BASH_COMMAND (status $status) at line $LINENO" >&2' ERR
publish "$1"
```

## Try it by hand
```bash
./solution.sh eel
RS_RC=7 ./solution.sh eel; echo "status=$?"
```

## Alternative
`trap '...' EXIT` also runs on failure, but it runs on success too and has lost
the line number by then. ERR is the one that fires at the failing command.

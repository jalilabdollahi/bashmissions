# Walkthrough: The Last Exit Status

## The plan
Run two searches, remember how each one ended, report both, and let the script's own exit status mirror the first search. The important point is timing.

## Step by step
`grep -q` prints nothing. It communicates only through its exit status: `0` when the pattern was found, `1` when not. The flags `-x` (whole line must match) and `-F` (treat the pattern as plain text) stop `dor` from matching `dory`.

```bash
grep -q -x -F "$HOST" fixtures/active.txt
```

Now `$?` holds the status of that grep. Copy it immediately:

```bash
active_rc=$?
```

If you ran anything in between, even `echo`, `$?` would describe *that* command instead. The same pair of lines for the second list:

```bash
grep -q -x -F "$HOST" fixtures/retired.txt
retired_rc=$?
```

Reporting is plain variable use:

```bash
echo "active=$active_rc"
echo "retired=$retired_rc"
```

Finally, make the script's own exit status say whether the server is active. `exit` accepts a number or a variable holding one:

```bash
exit "$active_rc"
```

## Complete solution
The two grep-and-save pairs, the two echo lines, and the exit line, in that order.

## Try it by hand
```
HOST=dory ./solution.sh; echo "script exit: $?"
HOST=haddock ./solution.sh; echo "script exit: $?"
```

## Alternative
Wrapping the command in `if grep -q ...; then` uses the status directly without ever naming it. That is the normal way to branch on success; reading `$?` is for when you need the number itself, as here.

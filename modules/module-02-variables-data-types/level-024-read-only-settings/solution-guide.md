# Walkthrough: Read-Only Settings

## The plan
Create the variable and lock it in one step. Print it. Then let the "careless" assignment run into the lock and watch Bash refuse it.

## Step by step
`readonly` can create a variable and freeze it in a single command:

```bash
readonly RETENTION_DAYS=$KEEP_DAYS
```

The first print proves the value made it in:

```bash
echo "retention: $RETENTION_DAYS days"
```

Now the careless line. It is an ordinary assignment, nothing special:

```bash
RETENTION_DAYS=$NEW_DAYS
```

Without the lock this silently changes the value and the next `echo` would report the wrong number. With the lock, Bash prints something like

```
solution.sh: line 6: RETENTION_DAYS: readonly variable
```

on stderr and leaves the variable untouched. The last `echo` therefore still reports the original number - proof that the guard held.

## Complete solution
```bash
#!/usr/bin/env bash
readonly RETENTION_DAYS=$KEEP_DAYS
echo "retention: $RETENTION_DAYS days"
RETENTION_DAYS=$NEW_DAYS
echo "retention now: $RETENTION_DAYS days"
```

## Try it by hand
```
KEEP_DAYS=30 NEW_DAYS=1 ./solution.sh
```
You should see the error, and both lines showing `30`. The status is `0`: the script itself did not fail, only that one assignment did.

## Alternative
You could just promise yourself not to touch the variable. That works until the script is 400 lines long and a colleague adds a line at the bottom. `readonly` turns the promise into a rule the shell enforces. (`declare -r` is the same thing with a different spelling.)

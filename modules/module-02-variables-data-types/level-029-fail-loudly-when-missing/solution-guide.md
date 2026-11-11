# Walkthrough: Fail Loudly When Missing

## The plan
Most settings should have a default. A database host should not: guessing one could dump the wrong database. So we want the script to refuse to continue, with a message that tells the operator exactly what is wrong.

## Step by step
Print the opening line first. Then comes the interesting part, the `:?` expansion:

```bash
host=${DB_HOST:?DB_HOST must be set}
```

Read it as: "the value of `DB_HOST`; if it is unset or empty, print the message after `:?` and stop". Bash writes something like this to stderr:

```
solution.sh: line 5: DB_HOST: DB_HOST must be set
```

and the script ends with status 1. Nothing after that line runs, so the final `echo` never prints a misleading success:

```bash
echo "dumping database on $host"
```

The first `echo` ran before the check, which is why `backup job starting` still appears in the failing runs. That is a useful reminder of the order things happen in.

## Complete solution
```bash
#!/usr/bin/env bash
echo "backup job starting"
host=${DB_HOST:?DB_HOST must be set}
echo "dumping database on $host"
```

## Try it by hand
```
DB_HOST=dory.lanternfish.example ./solution.sh
./solution.sh; echo "status: $?"
DB_HOST= ./solution.sh; echo "status: $?"
```
The last two commands should print the error and `status: 1`.

## Alternative
An `if [[ -z "$DB_HOST" ]]; then echo ... >&2; exit 1; fi` block does the same and lets you write a friendlier message. Bash's built-in form is shorter and cannot be forgotten halfway; use `if` when you need a custom exit code or a longer explanation.

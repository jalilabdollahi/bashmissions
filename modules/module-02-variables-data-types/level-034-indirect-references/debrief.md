# Debrief: Indirect References

## What you learned
A variable can hold the *name* of another variable. `${!name}` follows that name and returns the target's value. It is a small step from "variables hold values" to "variables can point at variables".

## Under the hood
Bash performs the expansion in two stages: it reads `quota_var` as usual, takes the resulting string, and uses it as the name for a second lookup. If the second variable does not exist, the result is empty, so the `:-` fallback applies naturally.

Be careful with where the name comes from. If it is built from untrusted input, a caller could make you read any variable you have, such as a secret that sits in the environment. Later, in the security module, you will see why such names should be checked against a list first.

## In real work
Settings named by pattern (`DB_HOST_primary`, `DB_HOST_replica`), per-customer or per-environment configuration, and generic helpers that print "the value of whichever variable you name".

## Going further
Next, the shell's own variable for reporting how the last command went: `$?`.

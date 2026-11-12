# Debrief: Fail Loudly When Missing

## What you learned
`${name:?message}` turns a missing setting into an immediate, readable failure. It is the third member of the family you have now met: `:-` substitutes, `:=` substitutes and stores, `:?` stops.

## Under the hood
When Bash expands `${name:?message}` and finds `name` unset or empty, it prints `name: message` to stderr, aborts the current command, and a non-interactive script exits with status 1. The status is the signal other tools use to notice that the job failed: a scheduler, a CI pipeline, or the next script in a chain. Output sent to stderr stays out of any file or pipe that captures stdout, so the error cannot be swallowed by accident.

Note that anything printed *before* the check still happened. Put the checks at the very top when you cannot afford half-finished work.

## In real work
The beginning of a serious script is often a block of `${VAR:?...}` lines, one per required setting. A clear message at the top is worth more than a confusing failure fifty lines later.

## Going further
You have used `:-` and `:?`, which both treat empty as missing. The next level asks when an empty value should *not* count as missing.

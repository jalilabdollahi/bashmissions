# Walkthrough: Talking to stderr

## The plan
A process owns two output streams. Stream 1, standard output, is for results. Stream 2, standard error, is for diagnostics. The terminal prints both in the same place, so you cannot see the difference until someone separates them, as cron's mail job does. We send the report to stream 1 and the warning to stream 2.

## Step by step
1. The report line already goes to stdout, the default. Leave it alone.
2. The warning needs to go to stderr. At the end of its command add `>&2`, which reads "redirect stdout of this command to wherever stderr points".
3. Check it: run the script with stderr thrown away, `bash solution.sh 2>/dev/null`. Only the report should remain.

## Complete solution

```bash
#!/usr/bin/env bash
echo "report: nightly sync complete on $HOST"
echo "warning: $HOST is using the spare disk" >&2
```

## Trying it by hand
`HOST=marlin bash solution.sh 2>/dev/null` shows the report only. `HOST=marlin bash solution.sh >/dev/null` shows the warning only.

## An alternative
`echo "..." 1>&2` is the same thing with the 1 spelled out. Writing `>&2` is the common shorthand, and putting it first, `>&2 echo "..."`, is also valid. Placing it at the end keeps the message easy to read.

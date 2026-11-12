# Debrief: Compliance Report

## What you learned

A compliance report is not magic: it is a list of questions, each answered from evidence, with the results counted. Writing each control as a function whose exit status is the verdict gives code that reads like the policy itself, and adding a new control means adding one function and one name.

## Under the hood

Shell functions return a status just like commands, so `if check_disk "$dir"` composes naturally with `&&`, `!` and `||`. `getopts` parses short options in a loop and sets `OPTIND` to the next unread argument, which `shift` consumes. The integer percentage rounds down on purpose: a report that rounds up can claim a pass that was not earned.

The threshold turns a report into a gate. A nightly job can run with `-m 90` and fail the pipeline only when the fleet score drops below the agreed level, while the full table still goes to the auditor.

## In real work

Frameworks such as CIS Benchmarks and SOC 2 controls look exactly like this at scale: a numbered list of checks, evidence gathered per host, and a score. Keep the evidence (not just the verdict) so an auditor can recheck a result months later, and store each report with its date.

## Going further

That completes the toolbox for running a fleet: backups, accounts, remote execution, certificates, audits and evidence. The next module puts them to work under pressure.

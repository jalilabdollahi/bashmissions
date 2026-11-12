# Debrief: Package Audit

## What you learned

Compliance questions are lookups against a policy. Turning the package list into an associative array makes each rule one line of logic, and writing the policy as data means auditors can change what is checked without touching the code.

## Under the hood

Version strings are not numbers and not plain text. `3.0.9` versus `3.0.13` compares correctly only when each dot-separated field is compared as an integer, from the left, stopping at the first difference. Debian versions are even richer (epochs, `~` for pre-releases, revisions after the dash), so this level compares only the upstream numeric prefix; real tools use `dpkg --compare-versions` for the full rules. The associative array needs Bash 4 or later, which is why macOS's old `/bin/bash` cannot run it.

Doing validation first, as a separate pass, is the same habit as in the cleanup level: finish checking the input before producing output people may act on.

## In real work

The same shape powers vulnerability scans ("is any installed package below the fixed version?") and licence audits ("forbid packages with licence X"). Running it per host over ssh, with the results in one table, gives a fleet-wide compliance view.

## Going further

Package state is static; service state changes. Next you will restart services across the fleet without taking everything down at once.

# Debrief: Provision Users from CSV

## What you learned

Any script that turns outside data into system changes is a gatekeeper. The data (a spreadsheet) is written by people; the changes (accounts) are hard to undo. The right shape is: parse, validate, check state, act, record the outcome, continue.

## Under the hood

`IFS=, read -r` is a field splitter, not a CSV parser: it knows nothing about quoted commas. That is fine for a controlled export with a simple schema, and a reason to validate each field. The username regex is a security control as much as a style rule, since the name ends up in file paths, home directories and sometimes shell commands.

Idempotence is the second big idea. A script that skips existing accounts can be re-run after a partial failure without making anything worse. Checking the state first, rather than catching the error afterwards, also gives a clearer report.

## In real work

Onboarding scripts like this usually also set a temporary password to expire at first login, add SSH keys, and write an audit line. Fleet tools such as Ansible and cloud-init do the same with a declared "this user should exist" model.

## Going further

Creating accounts is half of the lifecycle. Next you will write the other half: offboarding, which has to lock, preserve and report.

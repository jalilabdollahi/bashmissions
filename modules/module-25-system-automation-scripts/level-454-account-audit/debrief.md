# Debrief: Account Audit

## What you learned

The account database is a set of small, strict text files, and the smells an auditor looks for are all simple predicates over fields: a UID of zero, a shell where there should be none, a missing or empty password. Gathering findings into lists and printing them in a fixed order makes the output stable, which matters when you diff this week's report against last week's.

## Under the hood

Field 3 of passwd is the UID, and the kernel only cares about the number: any account with UID 0 is root in every way that counts, whatever its name. Two accounts sharing a UID share all file ownership, so they can read each other's files. In shadow, `*` or `!` in the hash field means no password login is possible; an empty field means no password is needed at all, which is the dangerous case.

`${line//[^:]/}` deletes everything except colons: a quick way to count separators without splitting. `${var+set}` is the standard way to distinguish an unset key from an empty value, here the difference between "no shadow entry" and "empty password".

## In real work

Audit tools such as Lynis, OpenSCAP and CIS-CAT include these checks and many more; scripts like yours are what small teams run first, from cron, with the output mailed to a person.

## Going further

You now have three audit tools. In the next level you will gather evidence during an incident into a folder with a manifest.

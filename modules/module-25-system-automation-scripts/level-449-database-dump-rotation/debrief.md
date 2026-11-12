# Debrief: Database Dump Rotation

## What you learned

A rotation script is only as trustworthy as its failure behaviour. The rule you implemented, never delete old backups until the new one is complete and verified, is the single most important property of any backup job. The second rule is that "the command ran" and "the output is good" are different facts, and pipelines hide the difference unless `pipefail` is on.

## Under the hood

Without `pipefail`, `pg_dump | gzip` exits with gzip's status; gzip happily compresses the few bytes pg_dump managed to print before the server went away. With it, the first failing stage determines the status. The `.partial` name means a crash never leaves something that looks like a finished dump, and rename is atomic, so any reader sees a complete file or none.

The regex-guarded database name and the digit-requiring glob are both about specificity: names are data, and `app` is a prefix of `app-staging`.

## In real work

Production versions add a restore test (load the dump into a scratch database), copy dumps off the machine, and alert if the newest dump is older than a day. For big databases `pg_dump -Fc` and physical backups replace plain SQL.

## Going further

You have been checking whether things exist. Next you will check what is listening: a port inventory across hosts.

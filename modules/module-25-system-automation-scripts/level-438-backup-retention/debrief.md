# Debrief: Backup Retention

## What you learned

Deleting is the dangerous half of backup work, so a retention rule has to be explicit, testable and previewable. You built a small policy engine: keep the recent dense history, thin out the older history to one point per week, and drop the rest.

## Under the hood

The whole thing rests on a naming convention. Because the stamp is `YYYYMMDD`, string order equals time order, and a glob (which is sorted) gives you a timeline with no date parsing. The weekday in the name makes the weekly rule a pattern match. Choosing names that sort correctly is one of the cheapest design decisions in automation.

The `-n` flag matters as much as the policy. A dry run prints exactly what the real run would do, so a human can review it before the first real deletion, and so a cron job can be switched to dry mode while you tweak the rules.

## In real work

Production versions add a floor ("never delete if fewer than 3 backups would remain") and a log of every deletion. Grandfather-father-son rotation, monthly keepers and cloud lifecycle rules are all the same idea at larger scale.

## Going further

A backup that exists is not a backup that works. Next you will write the checksum manifest that proves an archive is still intact.

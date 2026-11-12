# Debrief: Cron Inventory

## What you learned

Scheduled jobs are invisible infrastructure: they live in many files, belong to people who may have left, and run when nobody is watching. An inventory turns that into one reviewable table, and the act of writing the parser teaches you the format's quirks.

## Under the hood

A crontab has more than one line type. Environment settings (`MAILTO`, `PATH`, `SHELL`) apply to the jobs below them and are not jobs themselves. `@reboot`, `@daily` and friends replace the five time fields. Everything else is five fields separated by any amount of blanks or tabs, then a command that may itself contain spaces. `read` with a final catch-all variable handles that last point for free.

Keeping the column format in one `row` function is a small but valuable habit: header and data share a layout, so a change in one place changes both.

## In real work

Add `/etc/crontab`, `/etc/cron.d/*` and systemd timers to the inventory, and run it on every host over ssh. Look especially for jobs running as root, jobs running every minute, and jobs whose command no longer exists.

## Going further

A table of jobs was easy; a table of accounts is more delicate. Next you will audit passwd-style data for the classic security smells.

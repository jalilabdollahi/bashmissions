# Debrief: Timestamped Backup

## What you learned

A backup is three promises: it is complete, it is restorable, and it never replaces an older one. The stamp in the file name gives you the third promise for free, and the explicit "already exists" check protects it when someone runs the job twice.

## Under the hood

tar stores each member with the path you gave it. If you archive `/srv/www/site`, the archive remembers `srv/www/site/...` and a restore on another host drops files in a surprising place. `-C PARENT NAME` makes the stored paths start at the folder name instead. `tar -tzf` reads the gzip stream and prints member names without writing anything, which is the cheapest possible sanity check.

Passing the stamp in, rather than calling `date` inside, looks fussy but pays off: tests are repeatable, and a catch-up run can rebuild yesterday's name on purpose.

## In real work

Every serious backup tool does these things: write somewhere new, refuse to clobber, verify after writing. Accidental overwrites are how teams discover at 3 a.m. that their only copy was the broken one.

## Going further

Archives pile up forever unless something prunes them, and pruning is dangerous in its own right. Next you will write the retention policy.

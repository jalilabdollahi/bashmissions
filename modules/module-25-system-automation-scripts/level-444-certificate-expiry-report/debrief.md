# Debrief: Certificate Expiry Report

## What you learned

Expiry dates cause avoidable outages because nobody remembers them. A scheduled report that converts them to "days left" turns a surprise into a routine ticket. The technique you used, mapping a date to a single integer, is the portable way to do date arithmetic in shell without GNU extensions.

## Under the hood

openssl prints the end date as text in its own format, with a padded day (`Mar  4`). Using `read` to split on whitespace instead of `cut -d' '` avoids the classic bug where single-digit days shift the fields. The day-number formula works by starting the year in March, so February, the month with the irregular length, is last and the leap day needs no special case.

Passing TODAY in as an argument is deliberate: the script is deterministic, you can replay last Tuesday's report, and tests need no clock.

## In real work

Real checks also connect to the live host (`openssl s_client`) instead of reading files, and alert at 30, 14 and 7 days. Services such as Let's Encrypt renew at 30 days, so WARN at 30 doubles as "renewal is broken".

## Going further

Another slow disaster is a disk that fills up with logs. Next you will compress logs by age.

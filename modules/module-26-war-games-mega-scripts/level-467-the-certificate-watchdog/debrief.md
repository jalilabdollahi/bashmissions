# Debrief: The Certificate Watchdog

Certificate expiry is the classic "boring outage": predictable, preventable, and still the
cause of famous incidents. What makes a watchdog good is not cleverness, it is **where it
refuses to be clever**. It does not parse dates, it asks the tool that already knows (`-checkend`).
It does not trust an ambiguous exit code, it asks the specific question (`-enddate`) first. It
does not retry forever, it spends a fixed renewal budget. And it does not touch the live service
for every little change, it reloads once at the end, and only if anything changed.

Each of those is a pattern you will use again: *delegate calculations to the authority*, *check
cheap and specific conditions before ambiguous ones*, *put a ceiling on automation that talks to
external services*, and *batch side effects*. The status exit codes (0, 1, 2) with a separate
64 for misuse follow the conventions of monitoring plugins and `sysexits.h`, which makes the
script usable from Nagios, cron wrappers or CI without any translation layer.

One last habit: after changing something, look again. Re-inspecting after the renewal means the
report states what is now true, not what was true five seconds ago.

Going further: the next level is the whole dashboard: many services, one screen.

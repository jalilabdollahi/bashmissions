# Debrief: Log Levels and Filtering

Log levels solve a conflict: when you debug you want every detail, and when you
are on call at 3 a.m. you want only the lines that need a human. Instead of
two versions of the program, each message is tagged with how important it is,
and a single dial decides what is shown. That dial is a threshold: "this level
and everything more severe".

Under the hood the trick is turning an ordering of words into numbers. An
associative array (`declare -A`, Bash 4+) is a hash table, so `rank[WARN]`
gives 2 in one step, and arithmetic does the comparing. This is how syslog
(numeric severities 0 to 7), Python's `logging` and most libraries do it.

Reading the threshold from the environment is also the standard pattern: the
code stays the same, and the person or unit file that starts it decides. The
fallback with `${LOG_LEVEL:-INFO}` means a safe default if nobody set it, and
rejecting unknown values loudly prevents the worst failure of all, a typo
(`LOG_LEVEL=warning`) silently hiding everything or showing everything.

You will see exactly this in service managers, container images
(`LOG_LEVEL=debug`) and in the wrapper scripts around cron jobs.

Going further: next, you will make a logger write to a file *and* the screen,
so the quiet production run still leaves a record on disk.

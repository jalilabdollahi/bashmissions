# Debrief: The Cron Analyzer

A crontab is a small declarative language, and the right way to understand a declarative
language is to **evaluate it**: expand the lists, ranges and steps into concrete values and
look at the result. Once the schedule is a set of minutes, questions like "do these two
jobs ever run together?" stop being puzzles and become counting.

The fragile parts are the semantics, not the syntax. Cron's day-of-month / day-of-week rule is
an OR when both are restricted, `7` means Sunday as well as `0`, and a job's run time
decides whether it collides with its *own* next start, which is how a "harmless" every-30-minutes
sync quietly piles up processes. Writing those rules down as code (and as tests) is how you
learn them for good.

Design notes worth keeping: warnings go to stderr and do not stop the run, so one bad line does
not hide the other forty jobs; one expansion function serves every field, with only `lo` and `hi`
changing; and awk emits tagged rows so the shell can sort one part and print another, a handy
pattern when `sort` has to be applied to only some of the output.

Going further: the next mission compares two versions of a configuration, a diff with
opinions about which differences matter.

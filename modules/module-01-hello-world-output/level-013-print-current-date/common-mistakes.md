# Common Mistakes for Print Current Date

- Hard-coding a date string. The point of the level is to call `date` at runtime — typing `today is 2026-04-29` will pass the regex, but defeats the lesson and breaks every other day.

- Calling `date` without a format string. Plain `date` outputs `Wed Apr 29 14:07:33 UTC 2026` — way too long, and the regex won't match.

- Using the wrong format token. `%y` is a 2-digit year, `%Y` is 4-digit. The expected format is `%Y-%m-%d` (or its alias `%F`).

- Forgetting `$(...)` and writing `echo "today is date"` — this prints the literal word `date` instead of running it.

- Mixing dashes and slashes (`%Y/%m/%d`). The regex requires dashes.

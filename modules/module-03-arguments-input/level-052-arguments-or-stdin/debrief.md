# Debrief: Arguments or stdin

You just built the input behaviour of a well-mannered Unix tool. The rule of
thumb is that data goes through whichever door the caller finds convenient:
arguments for small, known values, stdin for piped or typed data. Supporting both
costs three lines, and makes the script usable in a terminal, in a pipeline and
from other scripts.

Three ideas combine here. `${1:-}` lets you peek at an optional argument without
triggering `set -u`. Guarding `read` behind an emptiness check preserves the
priority order, so stdin is only consumed when needed. And one final validation
catches every route that led to an empty value, which is simpler than validating
each route separately.

A cautionary note on priority: arguments win because they are explicit. A
script that read stdin first would hang forever whenever a human forgot to type,
which is why the fallback goes the other way round.

Going further: so far each script has read a single line. Next you will read
until the input runs out.

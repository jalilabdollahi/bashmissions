# Debrief: Version Guard

Bash scripts run on machines you do not control: a Mac that still ships bash 3.2, an
appliance with 4.1, a modern container with 5.2. Features such as associative arrays
(4.0), `${var,,}` (4.0), `mapfile` (4.0), `wait -n` (4.3) or `${var@Q}` (4.4) simply do
not exist on older versions, and the symptom is a syntax error far from the cause. A
version guard turns that into one sentence at the top: "needs bash 4.4, you have 3.2".

Bash exposes its version as `BASH_VERSINFO`, an array of numbers: major, minor, patch,
build, release status and platform. Use the numbers, not the `BASH_VERSION` string.
Text comparison gets "10" and "9" backwards, and the string contains build details you
do not care about. The comparison itself is the classic one for dotted versions:
compare the major; if it is equal, compare the minor.

Where to place the guard matters. Bash parses a command before it runs it, so
syntax that is new in a later version can fail to parse before your check executes.
Put the guard as the first command, and keep new-syntax code in functions defined
afterwards (a function body is parsed when it is defined, so for the strictest
cases move that code to a separate file you only source after the guard passes).

Going further: if you must run everywhere, you can avoid new features altogether. That
is the portability exercise in level 289.

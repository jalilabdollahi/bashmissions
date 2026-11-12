# Debrief: Settings from the Environment

Environment variables are the easiest way to configure a script: no flags to
parse, they pass through cron, systemd, containers and CI. They are also the least
checked input in your program: anyone upstream can set them, to anything, or forget
them entirely. So a well-behaved script has a small "settings" section that does
three things in a fixed order: **default** (`${VAR:-value}`), **validate** (right
shape, right range, allowed words), **use**. Everything after that section can trust
its variables.

`${VAR:-default}` substitutes the default when the variable is unset or empty. It also
solves the `set -u` problem, since the expansion is never unset. The colon matters:
without it, only an unset variable gets the default and an empty one slips through.
Validation order is not decoration: test that a value is digits before you do
arithmetic on it, because `(( x > 5 ))` with `x=abc` quietly treats `abc` as a
variable name, and with `x='1+1'` it evaluates an expression.

A good error message names the variable, states the rule, goes to stderr and exits
non-zero, so whoever starts the service sees it in the unit log at once.

Going further: the other safety property of a configured script is that you can run it
again, with the same settings, and nothing breaks. That is level 286.

# Debrief: Forget Secrets

A secret is safest where it is not. The attacker's mental model is "where does
this value end up?", and the environment is a surprisingly leaky place: it is
copied to every child process, shown in crash dumps, collected by diagnostic
tools, read from `/proc/PID/environ` on Linux by the same user, and printed by an
accidental `env` or `set -x`. Each of those is a path from your script to
somebody's log file.

The principle is **limited lifetime**. Read the secret as late as possible, use
it for exactly one purpose, and discard it as early as possible. `unset NAME`
removes the variable from the shell and therefore from the environment of
everything started afterwards. Copies matter: `token=$API_TOKEN` creates a second
home for the secret, so remove that too.

Be honest about the limits. `unset` does not erase memory that already held the
value, does not recall what a child has already received, and does not help if
the secret was also on a command line (visible in `ps`). Better still is to not
pass secrets in the environment or arguments at all, and to read them from a
file with tight permissions, as level 359 set up.

Going further: when a secret does get into a *log*, you need to scrub it out
after the fact. That is the last level.

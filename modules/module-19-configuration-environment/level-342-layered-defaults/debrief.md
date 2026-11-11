# Debrief: Layered Defaults

The mental model: **a setting is the answer to "who spoke last, and loudest?"**
Software ships with sensible defaults; an administrator's file adjusts them for
this machine; the environment adjusts them for this one run. Each layer is more
specific and more temporary than the one below, so it is allowed to override it.
Writing the layers in that order, weakest first, makes the code a picture of the
rule.

The detail that bites is "what counts as not provided". `${VAR:-x}` treats an
unset variable and an empty one the same, which is usually what you want: a
deploy tool that exports `RELAY_HOST=` by accident should not blank the host. If
you need the difference, `${VAR-x}` (no colon) only reacts to unset.

Under the hood, `read` with `IFS='='` splits on that one character and gives the
last variable everything left, which is why values containing `=` survive.

This is the structure behind most Unix tools: `git` reads system, user and
repository config in turn; `ssh`, `npm` and `docker` do the same dance.
Knowing the rule lets you debug "why is it using port 25?" by asking which layer
set it.

Going further: environment variables are only one way to say "this run is
different". The next level adds command-line flags on top, the loudest layer of
all, and shows how to parse them without losing the rest of the stack.

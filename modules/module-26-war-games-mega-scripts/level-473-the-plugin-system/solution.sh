#!/usr/bin/env bash
# Plugin host: discover plugins from their headers, order them by dependencies and
# priority, run a hook in each one in isolation, report exactly what happened.
#   solution.sh [--plugins DIR] [--disable NAME]... list
#   solution.sh [--plugins DIR] [--disable NAME]... run HOOK [ARG...]

# TODO: option parsing, the two commands, hook name validation, DIR check (exit 2 / 3)
# TODO: discovery: read each plugin's first 15 lines for name / requires / priority (sed -n -E);
#       bad headers and duplicate names; disabled.list and --disable
# TODO: ordering: repeatedly pick the ready plugin with the lowest (priority, name); leftovers are cyclic
# TODO: status per ordered plugin: disabled / missing dependency / dependency disabled / not usable / ok
# TODO: list: the table with ORDER NAME PRIO STATUS and the exit status
# TODO: run: skip what is not ok or whose requirement failed; run the rest in a subshell that sources the
#       plugin and calls NAME__HOOK; host_log; status 78 for "no hook"
# TODO: the summary line and exit status

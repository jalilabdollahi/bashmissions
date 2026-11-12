#!/usr/bin/env bash
# Observability kit for shell scripts: metrics, logs, spans, one report.
#   solution.sh OUT metric inc NAME [N] | metric set NAME VALUE
#   solution.sh OUT log LEVEL MESSAGE...
#   solution.sh OUT span NAME -- COMMAND [ARGS...]
#   solution.sh OUT report [--slow N]
# Time comes from `date +%s`; trace and parent ids travel in OBS_TRACE / OBS_PARENT.

# TODO: usage, OUT must exist, validation of names, levels and numbers
# TODO: replace_file: write via a temp file in the same folder, then mv
# TODO: metric inc/set on a sorted "NAME VALUE" file
# TODO: log: structured line with timestamp, level, trace; bump the log.LEVEL metric
# TODO: span: allocate trace/span ids (persisted), run the command with OBS_TRACE and
#       OBS_PARENT exported, time it, record it, count total and errors, keep its status
# TODO: report: metrics, level counts and error lines, span tree per trace, summary

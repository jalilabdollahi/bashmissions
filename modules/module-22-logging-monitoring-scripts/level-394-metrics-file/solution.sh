#!/usr/bin/env bash
# Turn a web access log into a Prometheus metrics file (text format).
# Counters: requests per status code, total bytes, malformed lines.
# Gauge: largest single response. Publish atomically: write .tmp, then mv.

# TODO: arguments and "cannot read" check
# TODO: aggregate the valid lines (five fields, numeric status and bytes)
# TODO: write the HELP/TYPE/sample lines to OUTFILE.tmp
# TODO: move the finished file into place and report

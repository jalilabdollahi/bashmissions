#!/usr/bin/env bash
# Two messages, two streams: a customer report and a team warning.
# TODO: the warning must not travel with the report, send it to stderr.
echo "report: nightly sync complete on $HOST"
echo "warning: $HOST is using the spare disk"

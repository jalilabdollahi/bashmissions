#!/usr/bin/env bash
# Normal output goes to stdout (the default). >&2 redirects this one command's
# output to stderr, so the cron mail only carries the report.
echo "report: nightly sync complete on $HOST"
echo "warning: $HOST is using the spare disk" >&2

#!/usr/bin/env bash
# stdin: "<client> <status> <path>" per line. Report how many statuses are 5xx.
# TODO: two counters, a read loop, and one test deciding which counter grows.
cat > /dev/null
echo "server errors: 0 of 0 requests"

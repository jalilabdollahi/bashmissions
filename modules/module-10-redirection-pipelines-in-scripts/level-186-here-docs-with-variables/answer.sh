#!/usr/bin/env bash
customer=$1
host=$2
start=$3

# The delimiter (EOF) is unquoted, so the shell expands $var and ${var^^}
# inside the body before cat ever sees it.
cat <<EOF
Dear $customer,

We will update ${host^^} starting at $start UTC.
Please expect a restart of about 10 minutes.

Signed: $USER, Lanternfish Hosting
EOF

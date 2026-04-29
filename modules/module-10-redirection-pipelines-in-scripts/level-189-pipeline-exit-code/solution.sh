#!/usr/bin/env bash
set -u

false | true
statuses=("${PIPESTATUS[@]}")
echo "statuses=${statuses[*]}"

#!/usr/bin/env bash
# One report file per customer name given as an argument (names may contain spaces).
# TODO: usage check, mkdir reports, then a loop over every argument.
mkdir -p reports
echo "report for $1" > "reports/$1.txt"
echo "created reports/$1.txt"

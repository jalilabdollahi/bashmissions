#!/usr/bin/env bash
# Run cert-check on the domain in $1. Collect both of its output streams in
# cert.log (replacing the old file), then print "saved N lines".

domain=$1

# TODO: run cert-check with everything going to cert.log
# TODO: count the lines in the log and print the summary

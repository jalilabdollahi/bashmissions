#!/usr/bin/env bash
# Compliance report: four controls checked per host from its evidence folder,
# printed as a scorecard with a fleet percentage and a pass threshold.

# TODO: getopts for -f (failures only) and -m PCT (minimum score, default 100)
# TODO: validate PCT (0-100), then HOSTSDIR (given? a directory? any host folders?)
# TODO: four small check functions, each returning success or failure
# TODO: per host: run the checks, print the "HOST: P/4" header and the check lines
# TODO: fleet totals, integer percentage, verdict line, exit status

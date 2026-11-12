#!/usr/bin/env bash
# SLA monitor. Probes (one per minute per service) become uptime %, an error
# budget in minutes, and a verdict. Blind minutes (missing probes) count as down.
#   solution.sh [--strict] SLO PROBES

# TODO: parse --strict, check both files are readable
# TODO: pct_to_milli: "99.95" -> 99950 (thousandths of a percent), validate it
# TODO: read SLO into an ordered list plus associative arrays
# TODO: walk PROBES: validate each line, minute = epoch / 60, order check
# TODO: per service track first/last minute, bad minutes, current run, outages, longest
# TODO: gaps between probes are bad minutes too (and extend the current run)
# TODO: report in SLO order: uptime, allowed budget, status; exit 1 on any breach

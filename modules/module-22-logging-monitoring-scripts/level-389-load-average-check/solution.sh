#!/usr/bin/env bash
# Load check: read the three load averages from `uptime`, compare the 1-minute
# value with LIMIT, report OK/HIGH and whether the load is rising or falling.

# TODO: validate LIMIT (a number, decimals allowed)
# TODO: capture uptime, cut away everything up to "load average: "
# TODO: split "a, b, c" into three variables
# TODO: decimals need a tool that does floating point: let awk decide

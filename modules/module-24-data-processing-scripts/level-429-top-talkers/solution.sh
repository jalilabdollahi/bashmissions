#!/usr/bin/env bash
# "$1": firewall log "timestamp client bytes". "$2": how many to show (default 3).
# Rank clients by total bytes; print "<rank>. <client> requests=<n> bytes=<b>".

# TODO 1: n=${2:-3}; if it is not a positive whole number, usage on stderr, exit 2.
# TODO 2: awk: requests[$2]++ and bytes[$2] += $3 (a "-" adds nothing).
# TODO 3: END prints "client requests bytes"; sort by bytes (numeric, reverse),
#         then by client name.
# TODO 4: a last awk numbers the lines and stops after N of them.

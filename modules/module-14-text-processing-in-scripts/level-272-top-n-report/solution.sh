#!/usr/bin/env bash
# Usage: solution.sh LOG N
# Resolver log lines: <time> <client_ip> <name> <rcode>.
# Print "Top N NXDOMAIN names" and the N most queried names with rcode
# NXDOMAIN as "<rank>. <name> (<count>)".

# TODO 0: print the title line first (echo).
# TODO 1: awk: keep only rcode == "NXDOMAIN" lines, print the name.
# TODO 2: sort | uniq -c, strip the padding, order by count desc then name.
# TODO 3: head -n N, then a final awk that numbers the lines with NR.

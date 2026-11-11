#!/usr/bin/env bash
set -euo pipefail
# Domain report. solution.sh DOMAIN... prints "DOMAIN -> REGISTRAR" per argument.
# whois-lookup is slow: ask it once per distinct domain, never twice.

# TODO 1: no arguments -> usage on stderr, exit 2.
# TODO 2: declare -A cache, then write registrar_of DOMAIN:
#         if DOMAIN is not in the cache yet, call whois-lookup and store the answer;
#         either way, copy the cached answer into the variable "registrar".
# TODO 3: for each argument call registrar_of and print the line.
#         (Call it directly, not inside $( ), or the cache is lost with the subshell.)

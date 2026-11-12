#!/usr/bin/env bash
set -euo pipefail
# Paperwork numbers from stdin: invoice, ticket, reset KIND.
# gen_next KIND advances that series and leaves the formatted number in REPLY.

# TODO 1: declare -A counters (one entry per kind, 0 = nothing handed out yet).
# TODO 2: write gen_next KIND: check the kind (invoice or ticket, else error + exit 2),
#         add one to its counter, then printf -v REPLY with the right format
#         (INV-%04d for invoices, TCK-%03d for tickets).
# TODO 3: read lines; skip blank ones. "reset KIND" zeroes that counter (validate KIND too).
#         Any other first word is a kind: call gen_next (not in $( )) and print "$REPLY".

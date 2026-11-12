#!/usr/bin/env bash
# "$1": an invoice CSV with header "invoice,customer,amount,status".
# Print "<invoice> | <customer> | <amount>" for each row with status "open",
# then "open invoices: <count>".

# TODO 1: count=0, then open the file once for the whole loop (done < "$1").
# TODO 2: read and discard the header line before the loop.
# TODO 3: while IFS=, read -r into four variables; keep the last line even if
#         it has no newline, and skip lines where everything is empty.
# TODO 4: remove a trailing \r from status, compare it with "open", print.

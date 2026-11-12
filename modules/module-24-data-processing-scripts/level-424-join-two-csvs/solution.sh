#!/usr/bin/env bash
# "$1" invoices (invoice,customer_id,amount), "$2" customers (customer_id,name,city).
# Print invoice,name,amount for every invoice, UNKNOWN when the id has no match.

# TODO 1: a single awk call that is given the CUSTOMERS file first, then the invoices.
# TODO 2: while FNR == NR, remember name[$1] = $2 for data lines (first one wins).
# TODO 3: for the second file print the new header on its line 1, then each
#         invoice with name[$2], or UNKNOWN when ($2 in name) is false.
# TODO 4: strip \r and skip blank lines in both files.

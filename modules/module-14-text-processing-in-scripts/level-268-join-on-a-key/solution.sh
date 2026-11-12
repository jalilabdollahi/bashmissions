#!/usr/bin/env bash
# Usage: solution.sh CUSTOMERS INVOICES  (both "code,value", any order)
# Print "code,name,amount" for codes present in both files.

# TODO 1: sort each file on its first field (-t, -k1,1); <(...) hands the
#         sorted result to a command as if it were a file.
# TODO 2: join the two sorted streams on field 1, with -t, again.

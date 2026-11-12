#!/usr/bin/env bash
# "$1": subscriber log "email,updated,plan[,...]". Print the header and the
# newest row per (lowercased) email, sorted by email.

# TODO 1: read the header line yourself and print it (strip \r); an empty file
#         prints nothing and exits 0.
# TODO 2: pipe the rest of the same file into awk (the group { } < "$1" shares
#         one open file): for each valid row, key = tolower($1); keep the row
#         if the key is new or $2 >= the stored timestamp (text comparison!).
# TODO 3: reject empty emails and malformed timestamps with "skipped line N"
#         (N counts the header, so add 1 to awk's NR).
# TODO 4: END prints the kept rows; sort -t, -k1,1 orders them by email.

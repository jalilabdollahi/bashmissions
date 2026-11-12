#!/usr/bin/env bash
# Audit passwd + shadow copies: malformed lines, extra UID-0 accounts, shared
# UIDs, service accounts with login shells, empty passwords, missing shadow entries.

# TODO: usage / readable files
# TODO: read SHADOW into a lookup: name -> hash field (and remember which names exist)
# TODO: read PASSWD once, skipping comments/blanks; separate malformed lines from accounts
# TODO: collect per-check results in separate lists so the report order is fixed
# TODO: UID -> names table for the duplicate check, keeping first-appearance order
# TODO: print the groups in the required order, then the tally and exit status

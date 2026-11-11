#!/usr/bin/env bash
# The first argument of printf is the format; the rest fill the placeholders
# from left to right. Quoting keeps "North Pier Dental" as one value.
printf 'Customer: %s | open: %d | oldest: #%d\n' "$CUSTOMER" "$TICKETS" "$OLDEST"

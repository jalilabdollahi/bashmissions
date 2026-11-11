#!/usr/bin/env bash
# A number after the % is the field width. A minus sign means left-aligned.
printf '[%-10s] [%5s]\n' "HOST" "USERS"
printf '[%-10s] [%5d]\n' "$HOST" "$USERS"

#!/usr/bin/env bash
# Welcome-note script. Every use of the variable is quoted so the name is
# always ONE word, whatever characters it contains.

echo "Welcome, $CUSTOMER" > "$CUSTOMER.txt"
printf 'Filed: [%s]\n' "$CUSTOMER"

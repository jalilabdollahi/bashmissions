#!/usr/bin/env bash
# Welcome-note script, written in a hurry. It breaks on names with spaces
# and misbehaves on a customer called "*". Fix it by quoting the variables.

echo "Welcome, $CUSTOMER" > $CUSTOMER.txt
printf 'Filed: [%s]\n' $CUSTOMER

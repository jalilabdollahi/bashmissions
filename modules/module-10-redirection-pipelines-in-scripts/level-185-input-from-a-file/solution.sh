#!/usr/bin/env bash
# $1 = recipient, $2 = message file. If the file is missing, complain on stderr
# (exit 1). Otherwise run lantern-mail for the recipient and let it read the
# file as its standard input.

recipient=$1
file=$2

# TODO: check that the file is readable
# TODO: run lantern-mail with the file connected to its stdin

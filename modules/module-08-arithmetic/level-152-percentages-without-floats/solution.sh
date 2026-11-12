#!/usr/bin/env bash
# Status page usage figure with one decimal, no floating point allowed.
# USED in $1, TOTAL in $2. Print "usage: 37.5%".

# TODO: guard against TOTAL being 0 (message on stderr, exit 2)
# TODO: scale before dividing so the tenths survive: USED * 1000 / TOTAL
# TODO: split those tenths into a whole part and one decimal digit
# TODO: print them with a "." in between

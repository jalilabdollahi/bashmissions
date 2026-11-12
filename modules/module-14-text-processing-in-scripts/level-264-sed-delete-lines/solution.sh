#!/usr/bin/env bash
# "$1" is a DNS zone file. Print it without comment lines (first non-blank
# character is ";") and without blank or whitespace-only lines.

# TODO 1: a sed address that matches "optional blanks, then ;" and the d command.
# TODO 2: a second address for lines that are empty or only blanks.
#         Use one -e per rule.

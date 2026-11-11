#!/usr/bin/env bash
# "$1" is a job log. Print every block from a line containing "BEGIN backup"
# through the next line containing "END backup", markers included.

# TODO 1: run sed with -n so nothing is printed unless you say so.
# TODO 2: address = /first-pattern/,/last-pattern/ ; command = p

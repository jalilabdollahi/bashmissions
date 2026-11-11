#!/usr/bin/env bash
# "$1": host,role,cpu_percent per line. Print an aligned table with a header.
# Format for every row, header included: host in 12 columns left-aligned,
# a space, role in 10 left-aligned, a space, cpu in 5 right-aligned.

# TODO 1: print the header once, before any input is read (a BEGIN block).
# TODO 2: for each line, printf the three fields with the same format.
#         Remember: printf adds no newline, put \n at the end of the format.

#!/usr/bin/env bash
# Status board: read "HOST STATE LOAD DISK" rows from stdin and print an
# aligned table with a separator, alert markers and a summary line.

# TODO: first pass: read and validate every line, remember rows, find the widest host name
# TODO: header, separator and rows using printf widths (the host width is a variable)
# TODO: markers for disk >= 90% and for a state other than "up"
# TODO: summary line, or "no hosts" on stderr with exit 1

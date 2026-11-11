#!/usr/bin/env bash
# Access-log digest. Input: log lines on stdin, e.g.
#   203.0.113.7 - [07/Nov/2024:09:30:15] "GET /shop/cart HTTP/1.1" 502 1432
# Print "<status> <METHOD> <PATH>" for request lines, "skipped: <line>" for the rest.
# TODO: write a regex with () around the three pieces you need.
# TODO: on a match read the pieces from BASH_REMATCH, otherwise print the skipped line.

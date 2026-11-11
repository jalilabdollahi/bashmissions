#!/usr/bin/env bash
# Price grid: rows = 1..SERVERS, cells = 1..MONTHS, price = servers*months*12.
# TODO: usage check; outer loop over servers; inner loop over months that
# prints each cell without a newline; one newline after each inner loop.
printf 'servers 1:'
printf '%6d' 12
printf '\n'

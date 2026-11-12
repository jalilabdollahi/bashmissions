#!/usr/bin/env bash
# "$1": JSON Lines, one flat object per line.
# Print CSV: header "ts,host,status,msg", then the four values per object.

# TODO 1: print the header yourself (it is not in the input).
# TODO 2: write get(line, key): find "key": with index(), skip spaces, then
#         either read a quoted string (unescape \" and \\) or a bare token.
# TODO 3: null or missing -> empty; wrap cells containing , or " in quotes,
#         doubling inner quotes.
# TODO 4: strip \r, skip blank lines, print the four cells joined by commas.

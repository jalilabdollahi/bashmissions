#!/usr/bin/env bash
# "$1": a combined-format access log. Print "host date METHOD path status bytes"
# for good lines; "bad line N" on stderr for damaged ones.

# TODO 1: awk with the double quote as field separator: $1 is everything before
#         the request, $2 the request, $3 " status bytes ", $6 the agent.
# TODO 2: split() $1, $2 and $3 on spaces to get host, date, method, path ...
# TODO 3: validate the shape: six quotes, three-word request, 3-digit status.
# TODO 4: "-" bytes become 0. Blank lines are skipped silently, \r stripped.

#!/usr/bin/env bash
# Usage: solution.sh FILE KEY
# Print the value of KEY in a key=value file (last assignment wins).
# Not found: "key not found: KEY" on stderr, exit 1.

# TODO 1: remember whether you found the key (a flag variable) and its value.
# TODO 2: while IFS='=' read -r key value; do ... done < "$1"
#         "value" gets everything after the first =. Don't forget the last
#         line when it has no newline: the loop condition can also accept
#         a non-empty "$key".
# TODO 3: after the loop, print the value or fail with the message.

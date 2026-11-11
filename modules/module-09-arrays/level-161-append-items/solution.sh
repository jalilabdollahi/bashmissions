#!/usr/bin/env bash
# The web pool starts as anchovy + barracuda. New machines arrive on stdin,
# one per line. Add each to the END of the array, then print the pool and a
# "total: N" line.
pool=(anchovy barracuda)

# TODO: read stdin line by line; append every line to pool
#       (the last line may have no trailing newline)

# TODO: print each element on its own line, then total: N
printf '%s\n' "${pool[@]}"

#!/usr/bin/env bash
# Count firewall decisions on stdin: blocked (DROP|REJECT|DENY), allowed
# (ACCEPT|ALLOW), other. End with: blocked=<n> allowed=<n> other=<n>
# TODO: one regex per category, each with an alternation inside ( )
# TODO: make sure ACTION=DROPPED is not counted as DROP
blocked=0 allowed=0 other=0
while IFS= read -r line || [[ -n $line ]]; do
  other=$(( other + 1 ))
done
echo "blocked=$blocked allowed=$allowed other=$other"

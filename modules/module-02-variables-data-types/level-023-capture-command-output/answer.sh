#!/usr/bin/env bash
# Audit header: ask the shell to run a pipeline and keep its output.

# $( ... ) runs the commands inside and is replaced by whatever they print
# (minus the trailing newline). Assignments do not need extra quotes.
first=$(sort fixtures/servers.txt | head -n 1)
last=$(sort fixtures/servers.txt | tail -n 1)

echo "first: $first"
echo "last: $last"
echo "range: $first..$last"

#!/usr/bin/env bash
# Fleet counter. With the integer attribute, Bash treats whatever is
# assigned to total as an arithmetic expression.

declare -i total

total=$WEB+$DB+$CACHE
echo "servers: $total"

# On an integer variable += adds. On a normal one it would append text
# and give "62" instead of 8.
total+=2
echo "with spares: $total"

#!/usr/bin/env bash
total=0
down=0

# Open the file once, as our own descriptor number 3 (truncating it).
# From here on ">&3" means "write to that open file", from any command.
exec 3> report.txt

for svc in "$@"; do
  state=$(svc-status "$svc") || down=$(( down + 1 ))
  echo "$svc: $state" >&3
  total=$(( total + 1 ))
done

# Close descriptor 3: flushes and releases the file.
exec 3>&-

echo "checked $total services, $down down"

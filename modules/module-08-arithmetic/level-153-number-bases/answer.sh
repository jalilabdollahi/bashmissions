#!/usr/bin/env bash
set -euo pipefail

port_hex="$1"
mode_oct="$2"

# base#digits tells arithmetic how to read the digits. Without the prefix,
# "0644" would be read as octal anyway, but "1f90" would be an error.
port=$(( 16#$port_hex ))
mode=$(( 8#$mode_oct ))

echo "port=$port"
echo "mode=$mode"

# printf turns a plain decimal number back into another base.
printf 'port_octal=%o\n' "$port"
printf 'mode_hex=%x\n' "$mode"

#!/usr/bin/env bash
# Server profile card: every idea from this module in one script.

# Required: stop right here (status 1) when SERVER is missing or empty.
server=${SERVER:?SERVER must be set}

# A constant that nothing below may change.
readonly COMPANY="Lanternfish Hosting"

# Optional settings with defaults. The environment wins when it has a value.
role=${ROLE:-web}
ram=${RAM_GB:-8}
dimms=${DIMMS:-2}

# Integer variable: the right-hand side is evaluated as arithmetic.
declare -i per_dimm
per_dimm=$ram/$dimms

# Capture a command's output. The quotes keep the server name in one piece;
# a server with no entry leaves owner empty, and the fallback fills it in.
owner=$(grep "^$server:" fixtures/owners.txt | cut -d: -f2)
owner=${owner:-unassigned}

# Braces mark where $server ends, since an underscore could belong to a name.
cat <<EOF
=== $COMPANY ===
server: $server
role:   $role
memory: $ram GB ($dimms x $per_dimm GB)
owner:  $owner
slug:   ${server}_${role}
EOF

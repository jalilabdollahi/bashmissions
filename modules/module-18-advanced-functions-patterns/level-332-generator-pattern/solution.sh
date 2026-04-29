#!/usr/bin/env bash
set -euo pipefail

counter=0
next_id(){ ((++counter)); }
next_id
echo "id=$counter"
next_id
echo "id=$counter"

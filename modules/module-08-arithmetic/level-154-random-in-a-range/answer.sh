#!/usr/bin/env bash
set -euo pipefail

seed="$1"
low="$2"
high="$3"
count="$4"

# Assigning to RANDOM seeds the generator: same seed, same sequence.
RANDOM="$seed"

# Both ends are allowed, so there are high - low + 1 possible values.
size=$(( high - low + 1 ))

for (( i = 0; i < count; i++ )); do
  # RANDOM % size is 0 .. size-1; adding low moves it to low .. high.
  echo "slot=$(( low + RANDOM % size ))"
done

#!/usr/bin/env bash
set -euo pipefail

# $1 is whatever the caller typed after the script name.
# Quoting it keeps "Tidewater Books" together as one value.
echo "Ahoy, $1! Your Lanternfish account is ready."

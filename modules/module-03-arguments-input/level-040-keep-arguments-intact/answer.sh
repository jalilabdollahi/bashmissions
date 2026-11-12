#!/usr/bin/env bash
set -euo pipefail

# "$@" expands to every argument as a separate, still-quoted word.
# That is what keeps "Tidewater Books" together and "" alive.
bash fixtures/tag.sh "$@"

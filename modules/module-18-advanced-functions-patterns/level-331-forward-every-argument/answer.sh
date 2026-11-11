#!/usr/bin/env bash
set -euo pipefail

# "$@" expands to one word per original argument, spaces and all, and to
# nothing at all when there are none. The fixed words simply go first.
ticket() {
  tracker-cli new --source=cli "$@"
}

ticket "$@"

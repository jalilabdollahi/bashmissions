#!/usr/bin/env bash
set -euo pipefail

url=$1

# '#' removes the SHORTEST prefix that matches the pattern "*://".
# The shortest match ends at the first "://", so a redirect target later in the
# URL is left alone. If the pattern does not match at all, nothing is removed.
echo "${url#*://}"

#!/usr/bin/env bash
set -euo pipefail
# Decide host, port and tls for the mail relay from three layers:
# environment (RELAY_*) > optional config file in $1 > built-in defaults.

# TODO 1: start with the defaults: localhost, 25, off.
# TODO 2: if $1 names a readable file, read NAME=VALUE lines and replace the
#         matching setting when the value is not empty. Trim blanks.
# TODO 3: let non-empty RELAY_HOST / RELAY_PORT / RELAY_TLS in the environment win.
# TODO 4: print host=, port=, tls=.

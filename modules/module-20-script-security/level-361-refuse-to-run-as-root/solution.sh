#!/usr/bin/env bash
# Log rotator for logs/app.log. It must refuse to run as root (uid 0) before
# it touches any file. `id -u` prints the numeric user id.
set -euo pipefail

# TODO: read the user id with id -u and stop with the required message when it
# is 0. Compare numbers with (( ... )), not text.

mv logs/app.log logs/app.log.1
: > logs/app.log
echo "rotated"

#!/usr/bin/env bash
set -euo pipefail
# Provisioning tool plugin loader. solution.sh PLUGIN_DIR
# Every PLUGIN_DIR/NAME.sh defines plugin_NAME; source each one and run its function.

dir=$1

# TODO 1: if the directory is missing, report it on stderr and exit 1.
# TODO 2: loop over "$dir"/*.sh. Watch out: when nothing matches, the loop
#         sees the pattern itself as one "file".
# TODO 3: in the loop: work out NAME, source the file, print "loaded NAME",
#         then call plugin_NAME.
# TODO 4: if the loop found nothing, print "no plugins found".
